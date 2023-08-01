namespace Calendar.Api.Services.Interfaces;

public interface IAuthService
{
    public Task GetGroupByNameAsync();
    public Task GetUserInformationAsync();
}