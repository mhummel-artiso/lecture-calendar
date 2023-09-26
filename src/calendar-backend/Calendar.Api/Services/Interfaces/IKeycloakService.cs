using Calendar.Api.DTOs;

namespace Calendar.Api.Services.Interfaces;

public interface IKeycloakService
{
    /// <summary>
    /// Get assigned Calendars
    /// </summary>
    /// <param name="userId">User ID</param>
    /// <returns>A collection of <see cref="string"/></returns>
    Task<IEnumerable<string>?> GetAssignedCalendarsByUserAsync(string userId);

    /// <summary>
    /// Get instructors from Keycloak
    /// </summary>
    /// <returns>A nullable collection of <see cref="InstructorDTO"/></returns>
    Task<IEnumerable<InstructorDTO>?> GetInstructorsAsync();

    /// <summary>
    /// Get all calendar groups from keycloak
    /// </summary>
    /// <returns>A nullable collection of <see cref="UserCalendarKeycloakDTO"/></returns>
    Task<IEnumerable<UserCalendarKeycloakDTO>?> GetAllCalendarsAsync();
}