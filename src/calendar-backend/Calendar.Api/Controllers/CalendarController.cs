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
    public CalendarController(ICalendarService service,ILogger<CalendarController> logger)
    {
        this.service = service;

    }
    //// GET
    //[HttpGet]
    //public async Task<ActionResult<IEnumerable<ClassCalendar>>> GetCalendarItem()
    //{
    //    var result = service.GetCalendars();
    //    return Ok(result);
    //}


    [HttpPost]
    public async Task<ActionResult<Mongo.Db.Models.Calendar>> Calendar([FromBody] Mongo.Db.Models.Calendar calendar)
    {
        await service.AddCalendarAsync(calendar);
        return Ok(calendar);
    }

    //[HttpGet("week/{week}")]
    //[Authorize(Roles = "viewer,editor")]
    //public async Task<ActionResult<IEnumerable<CalendarItem>>> GetCalendarItem(int week)
    //{
    //    var result = service.GetCalendars();
    //    return Ok(result);
    //}
    //[HttpPost()]
    //[Authorize(Roles = "viewer,editor")]
    //public async Task<ActionResult> AddUser(int week)
    //{
    //    var result = service.GetCalendars();
    //    return Ok(result);
    //}
}