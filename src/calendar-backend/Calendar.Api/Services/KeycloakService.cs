using Calendar.Api.Services.Interfaces;
using Keycloak.AuthServices.Authorization;
using Keycloak.AuthServices.Sdk.Admin;

namespace Calendar.Api.Services;

public class KeycloakService : IKeycloakService
{
    private readonly IKeycloakClient client;
    private readonly KeycloakProtectionClientOptions options;
    public KeycloakService(IKeycloakClient client, KeycloakProtectionClientOptions options)
    {
        this.client = client;
        this.options = options;
    }

    // TODO fix implementation
    public async Task<IEnumerable<string>> GetGroupsForUserAsync(string userId)
    {
        var user = await client.GetUser(options.Realm, userId);
        return user?.Groups ?? Array.Empty<string>();
    }

    // Get members of a group (id, username, first Name, last name, email, ...)
    //http://localhost:8080/admin/realms/Calendar/groups/269072d2-19a8-4ea8-a367-fc85b6af1c53/members

    // Get all groups (with sub groups) with meta information (id, name, path, subgroups[])
    //http://localhost:8080/admin/realms/Calendar/groups

    // Get all users
    // http://localhost:8080/admin/realms/Calendar/users

    // Get single user
    // http://localhost:8080/admin/realms/Calendar/users/45171f94-33bb-439c-8765-7a69d0d6d79e

    // List in which groups the user is
    // http://localhost:8080/admin/realms/Calendar/users/45171f94-33bb-439c-8765-7a69d0d6d79e/groups

    // Get role mappings from group
    // http://localhost:8080/admin/realms/Calendar/groups/a12bd244-8ddf-4220-a9f1-b530891a5ec9/role-mappings

    // API
    // https://www.keycloak.org/docs-api/21.0.1/rest-api/index.html#_groups_resource

    // Login with
    // https://www.keycloak.org/docs/22.0.1/server_development/#admin-rest-api

    // NuGET dotnet add package Keycloak.Net --version 1.0.18

    // Authoriaze with client secret
    //curl -d "client_id=calendar-api" -d "client_secret=vTtq8mz0OKiUGLaQWpkNZdpdjLhYPsZ5" -d "grant_type=client_credentials" "http://localhost:8080/realms/Calendar/protocol/openid-connect/token"

}