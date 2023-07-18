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

namespace Calendar.Api.Controllers;

[ApiController]
[Route("v1/api/[controller]")]
public class CalendarController : ControllerBase
{
    private readonly ICalendarService service;
    private readonly IMapper mapper;
    private readonly ILogger<CalendarController> logger;

    public CalendarController(ICalendarService service, IMapper mapper, ILogger<CalendarController> logger)
    {
        this.service = service;
        this.mapper = mapper;
        this.logger = logger;
    }


    [HttpPost]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<UserCalendar>> AddCalendar([FromBody] CreateUserCalendarDTO calendar)
    {
        if (calendar == null)
        {
            return BadRequest();
        }

        var result = await service.AddCalendarAsync(mapper.Map<UserCalendar>(calendar));
        return Ok(result);
    }
    
    [HttpGet("{id}")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<UserCalendar>> GetCalendar(string id,[FromQuery] string? viewType)
    {
        if (string.IsNullOrEmpty(id))
        {
            return BadRequest();
        }

        try
        {
            var view = string.IsNullOrEmpty(viewType) ? ViewType.Week : Enum.Parse<ViewType>(viewType);
            var calendar = await service.GetCalendarMetadata(id);
            return Ok(calendar);
        }
        catch(Exception ex)
        {
            logger.LogError(ex, $"Failed to parse {nameof(viewType)}");
            return BadRequest(ex.Message);
        }
    }

    [HttpPut("{id}")]
    [Authorize(Roles = "editor")]
    public async Task <ActionResult<UserCalendar>> EditCalendar(string id, [FromBody] UpdateUserCalendarDTO calendar)
    {
        if (string.IsNullOrEmpty(id))
        {
            return BadRequest();
        }
        if (calendar == null)
        {
            return BadRequest();
        }        

        var result = await service.UpdateCalendarAsync(id, mapper.Map<UserCalendar>(calendar));
        return Ok(result);
    }


    [HttpDelete("{id}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<UserCalendar>> DeleteCalendar(string id)
    {
        if (string.IsNullOrEmpty(id))
        {
            return BadRequest();
        }

        var success = await service.DeleteCalendarByIdAsync(id);

        return Ok(success);
    }
}