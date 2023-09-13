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
        public KeycloakRestEnvironmentConfiguration LogTrace(ILogger logger)
        {
            foreach (var property in GetType().GetProperties())
            {
                logger.LogTrace("{PropName}={PropValue}",property.Name,property.GetValue(this));
            }
            return this;
        }
    }
}