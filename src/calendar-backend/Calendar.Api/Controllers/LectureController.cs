using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Calendar.Api.Controllers;

[ApiController]
[Route("v1/api/[controller]")]
public class LectureController : ControllerBase
{
    private readonly ILectureService service;
    private readonly IMapper mapper;
    private readonly ILogger<LectureController> logger;

    public LectureController(ILectureService service, IMapper mapper, ILogger<LectureController> logger)
    {
        this.service = service;
        this.mapper = mapper;
        this.logger = logger;
    }


    [HttpPost]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<Lecture>> AddLecture([FromBody] CreateLectureDTO lecture)
    {
        if (lecture == null)
        {
            return BadRequest();
        }

        var result = await service.AddLectureAsync(mapper.Map<Lecture>(lecture));
        return Ok(result);
    }

    // TODO: Methode muss noch überarbeitet werden
    [HttpGet("{lectureId}")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<Lecture>> GetLecture(string id)
    {
        if (string.IsNullOrEmpty(id))
        {
            return BadRequest();
        }

        try
        {
            var lecture = await service.GetLectureAsync(id);
            return Ok(lecture);
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpGet("calendar/{calendarId}")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<IEnumerable<Lecture>>> GetAllLecturesFromCalendar(string calendarId)
    {
        if (string.IsNullOrEmpty(calendarId))
        {
            return BadRequest();
        }

        try
        {
            var calendarEvent = await service.GetAllLecturesFromCalendarAsync(calendarId);
            return Ok(calendarEvent);
        }
        catch (Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    // TODO: Mit Samuel besprechen
    [HttpPut("{id}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<Lecture>> EditLecture(string id, [FromBody] UpdateLectureDTO lecture)
    {
        if (string.IsNullOrEmpty(id))
        {
            return BadRequest();
        }
        if (lecture == null)
        {
            return BadRequest();
        }

        var result = await service.UpdateLectureAsync(id, mapper.Map<Lecture>(lecture));
        return Ok(result);
    }


    [HttpDelete("{id}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<Lecture>> DeleteLecture(string id)
    {
        if (string.IsNullOrEmpty(id))
        {
            return BadRequest();
        }

        var success = await service.DeleteLectureByIdAsync(id);

        return Ok(success);
    }


}
