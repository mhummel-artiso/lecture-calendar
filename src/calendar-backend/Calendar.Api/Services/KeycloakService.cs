using Keycloak.AuthServices.Authorization;
using Keycloak.AuthServices.Sdk.Admin;
using Microsoft.Extensions.Options;

namespace Calendar.Api.Services.Interfaces;

public class KeycloakService : IKeycloakService
{
    private readonly IKeycloakClient client;
    private readonly KeycloakProtectionClientOptions options;
    public KeycloakService(IKeycloakClient client, KeycloakProtectionClientOptions options)
    {
        this.client = client;
        this.options = options;
    }
    public async Task<IEnumerable<string>> GetGroupsForUserAsync(string userId)
    {
        var user = await client.GetUser(options.Realm, userId);
        return user?.Groups ?? Array.Empty<string>();
    }
}