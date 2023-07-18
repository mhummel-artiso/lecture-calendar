using AutoMapper;
using Calendar.Api.DTOs.Create;
using Calendar.Api.DTOs.Update;
using Calendar.Api.Models;
using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Calendar.Api.Controllers;

[ApiController]
[Route("v1/api/[controller]")]
public class EventController : ControllerBase
{
    private readonly IEventService service;
    private readonly IMapper mapper;
    private readonly ILogger<EventController> logger;

    public EventController(IEventService service, IMapper mapper, ILogger<EventController> logger)
    {
        this.service = service;
        this.mapper = mapper;
        this.logger = logger;
    }

    [HttpPost("{calendarId}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<CalendarEvent>> AddEvent([FromBody] CreateCalendarEventDTO calendarEvent, string calendarId)
    {
        if (calendarEvent == null)
        {
            return BadRequest();
        }

        var result = await service.AddEventAsync(calendarId, mapper.Map<CalendarEvent>(calendarEvent));
        return Ok(result);
    }

    // TODO: Methode muss noch überarbeitet werden, hat momentan noch calendarName und lectureId
    [HttpGet("calendar/{calendarId}/{id}")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<UserCalendar>> GetEvent(string id)
    {
        try
        {
            var calendarEvent = await service.GetEventAsync(id);
            return Ok(calendarEvent);
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpGet("calendar/{calendarId}")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<IEnumerable <CalendarEvent>>> GetAllEventsFromCalendar(string calendarId)
    {
        try
        {
            var calendarEvent = await service.GetAllEventsFromCalendarAsync(calendarId);
            return Ok(calendarEvent);
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpPut("{id}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<CalendarEvent>> EditEvent(string id, [FromBody] UpdateCalendarEventDTO calendarEvent)
    {
        if (calendarEvent == null)
        {
            return BadRequest();
        }

        var result = await service.UpdateEventAsync(id, mapper.Map<CalendarEvent>(calendarEvent));
        return Ok(result);
    }


    [HttpDelete("{calendarId}/{id}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<CalendarEvent>> DeleteEvent(string calendarId, string id)
    {
        var success = await service.DeleteEventByIdAsync(calendarId, id);
        return Ok(success);
    }
}
