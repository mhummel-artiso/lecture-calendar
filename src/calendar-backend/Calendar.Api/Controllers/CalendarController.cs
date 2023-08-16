using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Api.DTOs.Create;
using Calendar.Api.DTOs.Update;
using Calendar.Api.Models;
using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using Keycloak.AuthServices.Sdk.Admin;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace Calendar.Api.Controllers;

[ApiController]
[Route("v1/api/[controller]")]
public class CalendarController : ControllerBase
{
    private readonly ICalendarService calendarService;
    private readonly IEventService eventService;
    private readonly ILectureService lectureService;
    private readonly IKeycloakService keycloakService;
    private readonly IMapper mapper;
    private readonly ILogger<CalendarController> logger;
    public CalendarController(ICalendarService calendarService,
        IEventService eventService,
        ILectureService lectureService,
        IKeycloakService keycloakService,
        IMapper mapper,
        ILogger<CalendarController> logger)
    {
        this.calendarService = calendarService;
        this.eventService = eventService;
        this.lectureService = lectureService;
        this.keycloakService = keycloakService;
        this.mapper = mapper;
        this.logger = logger;
    }

    #region UserCalendar

    [HttpPost]
    [Authorize(AuthPolicies.EDITOR)]
    public async Task<ActionResult<UserCalendarDTO>> AddCalendar([FromBody] CreateUserCalendarDTO? calendar)
    {
        if (calendar == null)
        {
            return BadRequest();
        }
        try
        {
            var result = await calendarService.AddCalendarAsync(mapper.Map<UserCalendar>(calendar));
            return CreatedAtAction(nameof(AddCalendar), mapper.Map<UserCalendarDTO>(result));
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(ex.Message);
        }
    }

    [HttpGet]
    [Authorize(AuthPolicies.VIEWER)]
    public async Task<ActionResult<IEnumerable<UserCalendarDTO>>> GetAssignedCalendars()
    {
        var nameIdentifier = HttpContext.User.FindFirst(ClaimTypes.NameIdentifier);
        if (nameIdentifier == null || string.IsNullOrEmpty(nameIdentifier.Value))
            return BadRequest("invalid user id");

        var groups = await keycloakService.GetAssignedCalendarsByUserAsync(nameIdentifier.Value);

        if (groups == null) return NotFound();

        var calendars = await calendarService.GetCalendarsByNamesAsync(groups);
        return Ok(mapper.Map<IEnumerable<UserCalendarDTO>>(calendars));
    }
    [HttpGet("all")]
    [Authorize(AuthPolicies.EDITOR)]
    public async Task<ActionResult<IEnumerable<UserCalendarDTO>>> GetAllCalendars()
    {
        var calendars = await calendarService.GetCalendars();
        return Ok(mapper.Map<IEnumerable<UserCalendarDTO>>(calendars));
    }
    [HttpGet("name/{calendarName}")]
    [Authorize(AuthPolicies.EDITOR_VIEWER)]
    public async Task<ActionResult<UserCalendarDTO>> GetCalendarByName(string calendarName, [FromQuery] bool includeEvents = false)
    {
        var calendar = (await calendarService.GetCalendarsByNamesAsync(new List<string>()
        {
            calendarName
        }, includeEvents)).FirstOrDefault();
        if (calendar == null)
            return NotFound();
        var mapped = mapper.Map<UserCalendarDTO>(calendar);
        return Ok(mapped);
    }

    [HttpGet("{calendarId}")]
    [Authorize(AuthPolicies.EDITOR_VIEWER)]
    public async Task<ActionResult<UserCalendarDTO>> GetCalendarById(string calendarId, [FromQuery] bool includeEvents = false)
    {
        var calendar = await calendarService.GetCalendarByIdAsync(calendarId, includeEvents);
        if (calendar == null)
            return NotFound();
        return Ok(mapper.Map<UserCalendarDTO>(calendar));
    }

    [HttpPut("{calendarId}")]
    [Authorize(AuthPolicies.EDITOR)]
    public async Task<ActionResult<UserCalendarDTO>> EditCalendar(string calendarId, [FromBody] UpdateUserCalendarDTO? calendar)
    {
        if (calendar == null)
        {
            return BadRequest();
        }

        var result = await calendarService.UpdateCalendarAsync(calendarId, mapper.Map<UserCalendar>(calendar));
        if (result == null)
            return NotFound();
        return Ok(mapper.Map<UserCalendarDTO>(result));
    }

    [HttpDelete("{calendarId}")]
    [Authorize(AuthPolicies.EDITOR)]
    public async Task<ActionResult<bool>> DeleteCalendar(string calendarId)
    {
        var success = await calendarService.DeleteCalendarByIdAsync(calendarId);
        return Ok(success);
    }

    #endregion

    #region CalendarEvents

    [HttpPost("{calendarId}/event")]
    [Authorize(AuthPolicies.EDITOR)]
    public async Task<ActionResult<CalendarEventDTO>> AddEvent(string calendarId, [FromBody] CreateCalendarEventDTO calendarEvent)
    {
        try
        {
            var mappedCalendarEvent = mapper.Map<CalendarEvent>(calendarEvent);

            var result = await eventService.AddEventAsync(calendarId, mappedCalendarEvent);

            if (result == null)
            {
                return BadRequest("Error at inserting");
            }

            var mappedResult = mapper.Map<IEnumerable<CalendarEventDTO>>(result);


            foreach (var mappedDto in mappedResult)
            {
                await AddLectureToEventAsync(mappedDto).ConfigureAwait(false);
                await AddCalendarToEventAsync(mappedDto).ConfigureAwait(false);
            }

            return CreatedAtAction(nameof(AddEvent), mappedResult);

        }
        catch (Exception ex)
        {
            // Not all is a Bad Request see:
            // - https://de.wikipedia.org/wiki/HTTP-Statuscode#4xx_%E2%80%93_Client-Fehler
            // - https://de.wikipedia.org/wiki/HTTP-Statuscode#5xx_%E2%80%93_Server-Fehler
            // use different http response codes to tell client what happened
            return BadRequest(ex.Message);
        }
    }

    [HttpGet("{calendarId}/event")]
    [Authorize(AuthPolicies.VIEWER)]
    public async Task<ActionResult<IEnumerable<CalendarEventDTO>>> GetAllEventsFromCalendar(string calendarId)
    {
        try
        {
            var calendarEvents = await eventService.GetAllEventsFromCalendarAsync(calendarId);
            if (calendarEvents is null)
                return BadRequest("Calendar not Found");

            var mappedDtos = mapper.Map<IEnumerable<CalendarEventDTO>>(calendarEvents);

            foreach (var mappedDto in mappedDtos)
            {
                await AddLectureToEventAsync(mappedDto).ConfigureAwait(false);
                await AddCalendarToEventAsync(mappedDto).ConfigureAwait(false);
            }
            return Ok(mappedDtos);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(ex.Message);
        }

    }

    [HttpGet("{calendarId}/event/{date}/{viewType}")]
    [Authorize(AuthPolicies.VIEWER)]
    public async Task<ActionResult<IEnumerable<CalendarEventDTO>>> GetAllEventsFromCalendar(string calendarId, DateTimeOffset date, string viewType)
    {
        try
        {
            var type = Enum.Parse<ViewType>(viewType);
            var calendarEvents = await eventService.GetEventsAsync(calendarId, type, date);
            if (calendarEvents == null)
                return NotFound();
            var mappedDtos = mapper.Map<IEnumerable<CalendarEventDTO>>(calendarEvents);
            foreach (var mappedDto in mappedDtos)
            {
                await AddLectureToEventAsync(mappedDto).ConfigureAwait(false);
                await AddCalendarToEventAsync(mappedDto).ConfigureAwait(false);
            }
            return Ok(mappedDtos);
        }
        catch (ArgumentException e)
        {
            logger.LogError(e, "fail to parse view type");
            return BadRequest("invalid view type");
        }
    }

    [HttpGet("{calendarId}/event/{eventId}")]
    [Authorize(AuthPolicies.EDITOR_VIEWER)]
    public async Task<ActionResult<UserCalendarDTO>> GetEvent(string calendarId, string eventId)
    {
        try
        {
            var calendarEvent = await eventService.GetEventAsync(calendarId, eventId);

            if (calendarEvent == null)
                return NotFound();
            var mappedDto = mapper.Map<CalendarEventDTO>(calendarEvent);
            await AddLectureToEventAsync(mappedDto);
            return Ok(mappedDto);
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }

    }

    [HttpPut("{calendarId}/event/{eventId}")]
    [Authorize(AuthPolicies.EDITOR)]
    public async Task<ActionResult<CalendarEventDTO>> EditEvent(string calendarId, string eventId, [FromBody] UpdateCalendarEventDTO calendarEvent)
    {
        if (eventId != calendarEvent.Id)
            return BadRequest("event id not the same like in body");

        try
        {
            var result = await eventService.UpdateEventAsync(calendarId, mapper.Map<CalendarEvent>(calendarEvent));
            if (result == null)
                return NotFound();
            var mappedDto = mapper.Map<CalendarEventDTO>(result);
            await AddLectureToEventAsync(mappedDto);
            return Ok(mappedDto);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpDelete("{calendarId}/event/{eventId}")]
    [Authorize(AuthPolicies.EDITOR)]
    public async Task<ActionResult<bool>> DeleteEvent(string calendarId, string eventId)
    {
        try
        {
            var success = await eventService.DeleteEventByIdAsync(calendarId, eventId);
            return Ok(success);
        }
        catch (KeyNotFoundException ex)
        {
            return BadRequest(ex.Message);
        }
    }
    [HttpPut("{calendarId}/series/{serieId}")]
    [Authorize(AuthPolicies.EDITOR)]
    public async Task<ActionResult<IEnumerable<CalendarEventDTO>>> EditSerie(string calendarId, string serieId, [FromBody] UpdateCalendarSeriesDTO calendarEvent)
    {

        if (serieId != calendarEvent.SeriesId)
            return BadRequest("serie id not the same");


        var result = await eventService.UpdateEventSeriesAsync(calendarId, mapper.Map<CalendarEvent>(calendarEvent));
        if (result == null)
            return NotFound();

        var mappedResult = mapper.Map<IEnumerable<CalendarEventDTO>>(result);

        foreach (var mappedDto in mappedResult)
        {
            await AddLectureToEventAsync(mappedDto).ConfigureAwait(false);
        }
        return Ok(mappedResult);
    }
    [HttpDelete("{calendarId}/series/{serieId}")]
    [Authorize(AuthPolicies.EDITOR)]
    public async Task<ActionResult<bool>> DeleteEventSerie(string calendarId, string serieId)
    {
        try
        {
            var success = await eventService.DeleteEventSeriesByIdAsync(calendarId, serieId);
            return Ok(success);
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    private async Task AddLectureToEventAsync(CalendarEventDTO eventDto)
    {
        if (string.IsNullOrWhiteSpace(eventDto.LectureId))
            return;
        var lecture = await lectureService.GetLectureByIdAsync(eventDto.LectureId);
        eventDto.Lecture = mapper.Map<LectureDTO>(lecture);
    }
    private async Task AddCalendarToEventAsync(CalendarEventDTO eventDto)
    {
        if (string.IsNullOrWhiteSpace(eventDto.CalendarId))
            return;
        var calendar = await calendarService.GetCalendarByIdAsync(eventDto.CalendarId);
        eventDto.Calendar = mapper.Map<UserCalendarDTO>(calendar);
    }

    #endregion

}