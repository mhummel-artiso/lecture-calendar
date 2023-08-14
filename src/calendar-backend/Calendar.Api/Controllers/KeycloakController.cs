using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Api.Models;
using Calendar.Api.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Calendar.Api.Controllers
{
    [ApiController]
    [Route("v1/api/[controller]")]
    public class KeycloakController : ControllerBase
    {
        private readonly IMapper mapper;
        private readonly ILogger<LectureController> logger;
        private readonly IKeycloakService keycloakService;

        public KeycloakController(IMapper mapper, ILogger<LectureController> logger, IKeycloakService keycloakService)
        {
            this.mapper = mapper;
            this.logger = logger;
            this.keycloakService = keycloakService;
        }


        [HttpGet("instructors")]
        [Authorize(AuthPolicies.EDITOR)]
        public async Task<ActionResult<IEnumerable<InstructorDTO>>> GetInstructors()
        {
            var instructors = await keycloakService.GetInstructorsAsync();

            if(instructors == null) return NotFound();

            return Ok(instructors);
        }

        [HttpGet("calendars")]
        [Authorize(AuthPolicies.EDITOR)]
        public async Task<ActionResult<IEnumerable<UserCalendarKeycloakDTO>>> GetSemester()
        {
            var allCalendars = await keycloakService.GetAllCalendarsAsync();

            if(allCalendars == null) return NotFound();

            return Ok(allCalendars);
        }
    }
}
