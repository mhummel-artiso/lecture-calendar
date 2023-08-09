using Calendar.Api.DTOs;
using Calendar.Api.Models;

namespace Calendar.Api.Services.Interfaces;

public interface IKeycloakService
{
    Task<IEnumerable<(string, string)>?> GetGroupsForUserAsync(string userId);

    Task<IEnumerable<InstructorDTO>?> GetInstructorsAsync();

    Task<IEnumerable<UserCalendarKeycloakDTO>?> GetAllCalendarsAsync();
}