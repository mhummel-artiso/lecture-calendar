using Calendar.Api.Models;
using System.ComponentModel;

namespace Calendar.Api.Configurations
{
    public class KeycloakRestEnvironmentConfiguration : IEnvironmentConfiguration<KeycloakRestEnvironmentConfiguration>
    {
        public string KEYCLOAK_BASE_URL { get; set; } = "";
        public string KEYCLOAK_REST_USER { get; set; } = "admin";
        [PasswordPropertyText]
        public string KEYCLOAK_REST_PASSWORD { get; set; }
        public string KEYCLOAK_REALM { get; set; } = "Calendar";
        public string KEYCLOAK_CALENDARS_GROUP_NAME { get; set; } = "Semesters";
        public string KEYCLOAK_INSTRUCTOR_GROUP_NAME { get; set; } = "Instructors";

        public KeycloakRestEnvironmentConfiguration Validate()
        {
            new EnvironmentConfigurationValidator()
                .CheckEnvironmentUri(KEYCLOAK_BASE_URL)
                .CheckEnvironment(KEYCLOAK_REST_USER)
                .CheckEnvironment(KEYCLOAK_REST_PASSWORD)
                .CheckEnvironment(KEYCLOAK_REALM)
                .CheckEnvironment(KEYCLOAK_CALENDARS_GROUP_NAME)
                .CheckEnvironment(KEYCLOAK_INSTRUCTOR_GROUP_NAME);
            return this;
        }
        public KeycloakRestEnvironmentConfiguration LogDebugValues(ILogger logger)
        {
            logger.LogDebug("KEYCLOAK_BASE_URL={KeycloakBaseUrl}", KEYCLOAK_BASE_URL);
            logger.LogDebug("KEYCLOAK_REST_USER={KeycloakRestUser}", KEYCLOAK_REST_USER);
            logger.LogDebug("KEYCLOAK_REST_PASSWORD={KeycloakRestPassword}", KEYCLOAK_REST_PASSWORD);
            logger.LogDebug("KEYCLOAK_REALM={KeycloakRealm}", KEYCLOAK_REALM);
            logger.LogDebug("KEYCLOAK_CALENDARS_GROUP_NAME={KeycloakCalendarsGroupName}", KEYCLOAK_CALENDARS_GROUP_NAME);
            logger.LogDebug("KEYCLOAK_INSTRUCTOR_GROUP_NAME={KeycloakInstructorGroupName}", KEYCLOAK_INSTRUCTOR_GROUP_NAME);
            return this;
        }
    }
}