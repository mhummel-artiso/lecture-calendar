using Calendar.Api.Models;

namespace Calendar.Api.Configurations
{
    public class PostgreSqlEnvironmentConfiguration : IEnvironmentConfiguration<PostgreSqlEnvironmentConfiguration>
    {
        public string? POSTGRESQL_HOST { get; set; } = null;
        public int POSTGRESQL_PORT { get; set; } = 5432;
        public string POSTGRESQL_DATABASE { get; set; } = "lecture-calendar";
        public string? POSTGRESQL_USER_NAME { get; set; } = "postgres";
        public string? POSTGRESQL_USER_PASSWORD { get; set; } = null;
        public string GetConnectionString()
        {
            return $"postgresql://{POSTGRESQL_USER_NAME}:{POSTGRESQL_USER_PASSWORD}@{POSTGRESQL_HOST}:{POSTGRESQL_PORT}/{POSTGRESQL_DATABASE}";
            // return $"Host={POSTGRESQL_HOST};Database={POSTGRESQL_DATABASE};Username={POSTGRESQL_USER_NAME};Password={POSTGRESQL_USER_PASSWORD}";
        }

        /// <inheritdoc/>
        public PostgreSqlEnvironmentConfiguration Validate()
        {
            new EnvironmentConfigurationValidator()
                .CheckEnvironment(POSTGRESQL_HOST)
                .CheckEnvironmentValue(POSTGRESQL_PORT)
                .CheckEnvironment(POSTGRESQL_DATABASE)
                .CheckEnvironment(POSTGRESQL_USER_NAME).CheckEnvironment(POSTGRESQL_USER_PASSWORD);
            return this;
        }
    }
}