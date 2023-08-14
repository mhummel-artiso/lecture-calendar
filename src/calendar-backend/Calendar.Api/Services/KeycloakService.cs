using Calendar.Api.Configurations;
using Calendar.Api.DTOs;
using Calendar.Api.Services.Interfaces;
using FS.Keycloak.RestApiClient.Api;
using FS.Keycloak.RestApiClient.Client;
using Microsoft.Extensions.Options;

namespace Calendar.Api.Services;

public class KeycloakService : IKeycloakService
{
    private readonly KeycloakHttpClient httpClient;
    private readonly string realm;
    private readonly string calendarsGroupName;
    private readonly string instructorGroupName;

    public KeycloakService(KeycloakHttpClient httpClient, IOptions<KeycloakRestEnvironmentConfiguration> options)
    {
        this.httpClient = httpClient;
        realm = options.Value.KEYCLOAK_REALM;
        calendarsGroupName = options.Value.KEYCLOAK_CALENDARS_GROUP_NAME;
        instructorGroupName = options.Value.KEYCLOAK_INSTRUCTOR_GROUP_NAME;
    }

    public async Task<IEnumerable<string>?> GetAssignedCalendarsByUserAsync(string userId)
    {
        using var userApi = ApiClientFactory.Create<UserApi>(httpClient);
        var assignedGroupsFromUser = await userApi.GetUsersGroupsByIdAsync(realm, userId);

        if (assignedGroupsFromUser == null) return null;

        return assignedGroupsFromUser
            .Where(x => x.Path.StartsWith($"/{calendarsGroupName}/"))
            .Select(x => x.Name);
    }

    public async Task<IEnumerable<InstructorDTO>?> GetInstructorsAsync()
    {
        using var groupsApi = ApiClientFactory.Create<GroupsApi>(httpClient);

        var groups = await groupsApi.GetGroupsAsync(realm);

        if (groups == null) return null;

        var instructorGroup = groups.FirstOrDefault(x => x.Name.Equals(instructorGroupName));

        if (instructorGroup == null) return null;

        using var groupApi = ApiClientFactory.Create<GroupApi>(httpClient);
        var groupMembers = await groupApi.GetGroupsMembersByIdAsync(realm, instructorGroup.Id);

        return groupMembers?.Select(user => new InstructorDTO()
        {
            Id = user.Id, Name = $"{user.FirstName} {user.LastName}"
        });
    }

    public async Task<IEnumerable<UserCalendarKeycloakDTO>?> GetAllCalendarsAsync()
    {
        using var groupsApi = ApiClientFactory.Create<GroupsApi>(httpClient);
        var groups = await groupsApi.GetGroupsAsync(realm);

        if (groups == null) return null;

        var semesterGroup = groups.FirstOrDefault(x => x.Name.Equals(calendarsGroupName));

        if (semesterGroup == null) return null;

        return semesterGroup.SubGroups.Select(group => new UserCalendarKeycloakDTO()
        {
            KeycloakGroupId = group.Id, Name = group.Name
        });

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