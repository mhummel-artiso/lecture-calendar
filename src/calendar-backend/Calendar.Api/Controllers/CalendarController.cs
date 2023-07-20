using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Api.DTOs.Create;
using Calendar.Api.DTOs.Update;
using Calendar.Api.Models;
using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
using System.Collections;
using System.Security.Claims;

namespace Calendar.Api.Controllers;

[ApiController]
[Route("v1/api/[controller]")]
public class CalendarController : ControllerBase
{
    private readonly ICalendarService calendarService;
    private readonly IEventService eventService;
    private readonly IMapper mapper;
    private readonly ILogger<CalendarController> logger;

    public CalendarController(ICalendarService calendarService, IEventService eventService, IMapper mapper, ILogger<CalendarController> logger)
    {
        this.calendarService = calendarService;
        this.eventService = eventService;
        this.mapper = mapper;
        this.logger = logger;
    }

    #region UserCalendar

    [HttpPost]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<UserCalendarDTO>> AddCalendar([FromBody] CreateUserCalendarDTO calendar)
    {
        if (calendar == null)
        {
            return BadRequest();
        }

        var result = await calendarService.AddCalendarAsync(mapper.Map<UserCalendar>(calendar));

        return Ok(mapper.Map<UserCalendarDTO>(result));
    }

    [HttpGet]
    //[Authorize(Roles = "calendar-viewer,calendar-editor")]
    [Authorize]
    public async Task<ActionResult<IEnumerable<UserCalendarDTO>>> GetCalendarsByNames()
    {
        var groups = base.HttpContext.User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.GroupSid);
        var testdata = new List<string>
        {
            "TINF21AI"
        }; // TODO: use groups from claim 
        var calendar = await calendarService.GetCalendarsByNamesAsync(testdata);

        return Ok(mapper.Map<IEnumerable<UserCalendarDTO>>(calendar));
    }

    [HttpGet("{calendarId}")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<UserCalendarDTO>> GetCalendarById(string calendarId, [FromQuery] bool includeEvents = false)
    {
        var calendar = await calendarService.GetCalendarByIdAsync(calendarId, includeEvents);
        if (calendar == null)
            return NotFound();
        return Ok(mapper.Map<UserCalendarDTO>(calendar));
    }

    [HttpPut("{calendarId}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<UserCalendarDTO>> EditCalendar(string calendarId, [FromBody] UpdateUserCalendarDTO calendar)
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
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<bool>> DeleteCalendar(string calendarId)
    {
        var success = await calendarService.DeleteCalendarByIdAsync(calendarId);
        return Ok(success);
    }

    #endregion

    #region CalendarEvents

    [HttpPost("{calendarId}/event")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<CalendarEventDTO>> AddEvent(string calendarId, [FromBody] CreateCalendarEventDTO calendarEvent)
    {
        if (calendarEvent == null)
        {
            return BadRequest();
        }

        var result = await eventService.AddEventAsync(calendarId, mapper.Map<CalendarEvent>(calendarEvent));

        return Ok(mapper.Map<CalendarEventDTO>(result));
    }

    [HttpGet("{calendarId}/event")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<IEnumerable<CalendarEventDTO>>> GetAllEventsFromCalendar(string calendarId)
    {
        var calendarEvents = await eventService.GetAllEventsFromCalendarAsync(calendarId);
        return Ok(mapper.Map<IEnumerable<CalendarEventDTO>>(calendarEvents));
    }

    [HttpGet("{calendarId}/event/{eventId}")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<UserCalendarDTO>> GetEvent(string calendarId, string eventId)
    {
        var calendarEvent = await eventService.GetEventAsync(calendarId, eventId);

        if (calendarEvent == null)
            return NotFound();

        return Ok(mapper.Map<CalendarEventDTO>(calendarEvent));
    }

    [HttpPut("{calendarId}/event/{eventId}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<CalendarEventDTO>> EditEvent(string eventId, [FromBody] UpdateCalendarEventDTO calendarEvent)
    {
        if (calendarEvent == null)
        {
            return BadRequest();
        }

        var result = await eventService.UpdateEventAsync(eventId, mapper.Map<CalendarEvent>(calendarEvent));
        if (result == null)
            return NotFound();
        return Ok(mapper.Map<CalendarEventDTO>(result));
    }

    [HttpDelete("{calendarId}/event/{eventId}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<bool>> DeleteEvent(string calendarId, string eventId)
    {
        var success = await eventService.DeleteEventByIdAsync(calendarId, eventId);
        return Ok(success);
    }

    #endregion

}