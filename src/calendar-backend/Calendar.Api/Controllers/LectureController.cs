﻿using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Api.DTOs.Create;
using Calendar.Api.DTOs.Update;
using Calendar.Api.Exceptions;
using Calendar.Api.Models;
using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

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
    [Authorize(AuthPolicies.EDITOR)]
    public async Task<ActionResult<LectureDTO>> AddLecture([FromBody] CreateLectureDTO? lecture)
    {
        if (lecture == null)
        {
            return BadRequest();
        }
        var data = mapper.Map<Lecture>(lecture);
        var result = await service.AddLectureAsync(data);
        var d = mapper.Map<LectureDTO>(result);
        return Created(nameof(AddLecture), d);
    }

    [HttpGet]
    [Authorize(AuthPolicies.EDITOR_VIEWER)]
    public async Task<ActionResult<IEnumerable<LectureDTO>>> GetLectures()
    {
        var lecture = await service.GetLecturesAsync();
        return Ok(mapper.Map<IEnumerable<LectureDTO>>(lecture));
    }

    [HttpGet("{lectureId}")]
    [Authorize(AuthPolicies.EDITOR_VIEWER)]
    public async Task<ActionResult<LectureDTO>> GetLectureById(string lectureId)
    {
        var lecture = await service.GetLectureByIdAsync(lectureId);

        if (lecture == null)
        {
            return NotFound();
        }

        return Ok(mapper.Map<LectureDTO>(lecture));
    }

    [HttpPut("{lectureId}")]
    [Authorize(AuthPolicies.EDITOR)]
    public async Task<ActionResult<LectureDTO>> EditLecture(string lectureId, [FromBody] UpdateLectureDTO lecture)
    {
        if (lectureId != lecture.Id)
            return BadRequest("lecture id not the same like in body");

        try
        {
            var updatedLecture = await service.UpdateLectureAsync(lectureId, mapper.Map<Lecture>(lecture));
            return Ok(mapper.Map<LectureDTO>(updatedLecture));
        }
        catch(KeyNotFoundException ex)
        {
            return NotFound(ex.Message);
        }
        catch(ConflictException<Lecture> ex)
        {
            return Conflict(mapper.Map<LectureDTO>(ex.NewestEvent));
        }
        catch(Exception ex)
        {
            return BadRequest(ex.Message);
        }
    }

    [HttpDelete("{lectureId}")]
    [Authorize(AuthPolicies.EDITOR)]
    public async Task<ActionResult<bool>> DeleteLecture(string lectureId)
    {
        var success = await service.DeleteLectureByIdAsync(lectureId);

        return Ok(success);
    }
}