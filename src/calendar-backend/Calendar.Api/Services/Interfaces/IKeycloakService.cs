namespace Calendar.Api.Services.Interfaces;

public interface IKeycloakService
{
    Task<IEnumerable<string>> GetGroupsForUserAsync(string userId);
}