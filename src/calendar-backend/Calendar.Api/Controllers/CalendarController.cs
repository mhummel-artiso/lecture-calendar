using AutoMapper;
using Calendar.Api.DTOs.Create;
using Calendar.Api.DTOs.Update;
using Calendar.Api.Models;
using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
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
    public async Task<ActionResult<UserCalendar>> AddCalendar([FromBody] CreateUserCalendarDTO calendar)
    {
        if (calendar == null)
        {
            return BadRequest();
        }

        var result = await calendarService.AddCalendarAsync(mapper.Map<UserCalendar>(calendar));
        return Ok(result);
    }

    [HttpGet]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<UserCalendar>> GetCalendarsByNames()
    {
        var groups = base.HttpContext.User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.GroupSid);

        var testdata = new List<string> {"TINF21AI"};   // TODO: use groups from claim 
        var calendar = await calendarService.GetCalendarsByNamesAsync(testdata);
        return Ok(calendar);
       
    }

    [HttpGet("{calendarId}")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<UserCalendar>> GetCalendarById(string calendarId, [FromQuery] bool includeEvents = false)
    {             
        var calendar = await calendarService.GetCalendarByIdAsync(calendarId, includeEvents);
        return Ok(calendar);       
    }

    [HttpPut("{calendarId}")]
    [Authorize(Roles = "editor")]
    public async Task <ActionResult<UserCalendar>> EditCalendar(string calendarId, [FromBody] UpdateUserCalendarDTO calendar)
    {
        if (calendar == null)
        {
            return BadRequest();
        }        

        var result = await calendarService.UpdateCalendarAsync(calendarId, mapper.Map<UserCalendar>(calendar));
        return Ok(result);
    }


    [HttpDelete("{calendarId}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<UserCalendar>> DeleteCalendar(string calendarId)
    {
        var success = await calendarService.DeleteCalendarByIdAsync(calendarId);

        return Ok(success);
    }
    #endregion


    #region CalendarEvents
    [HttpPost("{calendarId}/event")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<CalendarEvent>> AddEvent([FromBody] CreateCalendarEventDTO calendarEvent, string calendarId)
    {
        if (calendarEvent == null)
        {
            return BadRequest();
        }

        var result = await eventService.AddEventAsync(calendarId, mapper.Map<CalendarEvent>(calendarEvent));
        return Ok(result);
    }

    [HttpGet("{calendarId}/event/{eventId}")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<UserCalendar>> GetEvent(string calendarId, string eventId)
    {
        
        var calendarEvent = await eventService.GetEventAsync(calendarId, eventId);

        if (calendarEvent == null)
        {
            return NotFound();
        }

        return Ok(calendarEvent);
    }

    [HttpGet("{calendarId}/event")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<IEnumerable<CalendarEvent>>> GetAllEventsFromCalendar(string calendarId)
    {
        var calendarEvent = await eventService.GetAllEventsFromCalendarAsync(calendarId);

        if (calendarEvent == null)
        {
            return NotFound();
        }

        return Ok(calendarEvent);
    }

    [HttpPut("{calendarId}/event/{eventId}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<CalendarEvent>> EditEvent(string eventId, [FromBody] UpdateCalendarEventDTO calendarEvent)
    {
        if (calendarEvent == null)
        {
            return BadRequest();
        }

        var result = await eventService.UpdateEventAsync(eventId, mapper.Map<CalendarEvent>(calendarEvent));
        return Ok(result);
    }


    [HttpDelete("{calendarId}/event/{eventId}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<CalendarEvent>> DeleteEvent(string calendarId, string eventId)
    {
        var success = await eventService.DeleteEventByIdAsync(calendarId, eventId);
        return Ok(success);
    }
    #endregion
}