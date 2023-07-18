using AutoMapper;
using Calendar.Api.DTOs.Create;
using Calendar.Api.DTOs.Update;
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

    [HttpGet("{lectureId}")]
    [Authorize(Roles = "viewer,editor")]
    public async Task<ActionResult<Lecture>> GetLectureById(string lectureId)
    {
        var lecture = await service.GetLectureByIdAsync(lectureId);

        if (lecture == null)
        {
            return NotFound();
        }

        return Ok(lecture);
        
    }

    [HttpPut("{lectureId}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<Lecture>> EditLecture(string lectureId, [FromBody] UpdateLectureDTO lecture)
    {
        if (lecture == null)
        {
            return BadRequest();
        }

        var result = await service.UpdateLectureAsync(lectureId, mapper.Map<Lecture>(lecture));
        return Ok(result);
    }

    [HttpDelete("{lectureId}")]
    [Authorize(Roles = "editor")]
    public async Task<ActionResult<Lecture>> DeleteLecture(string lectureId)
    {
        var success = await service.DeleteLectureByIdAsync(lectureId);

        return Ok(success);
    }
}
