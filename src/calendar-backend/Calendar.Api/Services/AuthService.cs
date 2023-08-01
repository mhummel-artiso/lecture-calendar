using Calendar.Api.Services.Interfaces;

namespace Calendar.Api.Services;

public class AuthService : IAuthService
{
    private readonly IHttpClientFactory clientFactory;
    public AuthService(IHttpClientFactory clientFactory)
    {
        this.clientFactory = clientFactory;

    }
    public async Task GetGroupByNameAsync() => throw new NotImplementedException();
    public async Task GetUserInformationAsync() => throw new NotImplementedException();
}