using Calendar.Api.DTOs;

namespace Calendar.Api.Services.Interfaces;

public interface IKeycloakService
{
    Task<IEnumerable<string>?> GetAssignedCalendarsByUserAsync(string userId);

    Task<IEnumerable<InstructorDTO>?> GetInstructorsAsync();

    Task<IEnumerable<UserCalendarKeycloakDTO>?> GetAllCalendarsAsync();
}