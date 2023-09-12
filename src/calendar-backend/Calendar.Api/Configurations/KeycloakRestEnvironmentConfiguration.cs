using Calendar.Api.Models;

namespace Calendar.Api.Configurations
{
    public class KeycloakRestEnvironmentConfiguration : IEnvironmentConfiguration<KeycloakRestEnvironmentConfiguration>
    {
        public string KEYCLOAK_BASE_URL { get; set; } = "";
        public string KEYCLOAK_REST_USER { get; set; } = "admin";
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
        public KeycloakRestEnvironmentConfiguration LogDebugValues(ILogger<KeycloakRestEnvironmentConfiguration> logger)
        {
            logger.LogDebug("KEYCLOAK_BASE_URL={KeycloakBaseUrl}",KEYCLOAK_BASE_URL);
            logger.LogDebug("KEYCLOAK_REST_USER={KeycloakRestUser}",KEYCLOAK_REST_USER);
        }
    }
}
