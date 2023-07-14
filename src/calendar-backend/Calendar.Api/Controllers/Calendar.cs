using Calendar.Api.Models;
using Calendar.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Calendar.Api.Controllers;

[ApiController]
[Route("v1/api/[controller]")]
public class CalendarController : ControllerBase
{
    private readonly ICalendarService service;
    public CalendarController(ICalendarService service,ILogger<CalendarController> logger)
    {
        this.service = service;

    }
    // GET
    [HttpGet]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<IEnumerable<CalendarItem>>> GetCalendarItem()
    {
        var result = service.GetCalendars();
        return Ok(result);
    }
    [HttpGet("week/{week}")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<IEnumerable<CalendarItem>>> GetCalendarItem(int week)
    {
        var result = service.GetCalendars();
        return Ok(result);
    }
    [HttpPost()]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult> AddUser(int week)
    {
        var result = service.GetCalendars();
        return Ok(result);
    }
}