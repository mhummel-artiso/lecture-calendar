using Calendar.Api.Models;

namespace Calendar.Api.Configurations
{
    [Obsolete]
    public class PostgreSqlEnvironmentConfiguration : IEnvironmentConfiguration<PostgreSqlEnvironmentConfiguration>
    {
        public string? POSTGRESQL_HOST { get; set; } = null;
        public int POSTGRESQL_PORT { get; set; } = 5432;
        public string POSTGRESQL_DATABASE { get; set; } = "lecture-calendar";
        public string? POSTGRESQL_USER_NAME { get; set; } = "postgres";
        public string? POSTGRESQL_USER_PASSWORD { get; set; } = null;
        public string GetConnectionString(string? database = null)
        {
            var str = $"postgresql://{POSTGRESQL_USER_NAME}:{POSTGRESQL_USER_PASSWORD}@{POSTGRESQL_HOST}:{POSTGRESQL_PORT}";
            return string.IsNullOrEmpty(database)
                ? $"{str}/{POSTGRESQL_DATABASE.TrimStart('/')}"
                : $"{str}/{database.TrimStart('/')}";
        }
        /// <inheritdoc/>
        public PostgreSqlEnvironmentConfiguration Validate()
        {
            new EnvironmentConfigurationValidator()
                .CheckEnvironment(POSTGRESQL_HOST)
                .CheckEnvironmentNumber(POSTGRESQL_PORT)
                .CheckEnvironment(POSTGRESQL_DATABASE)
                .CheckEnvironment(POSTGRESQL_USER_NAME)
                .CheckEnvironment(POSTGRESQL_USER_PASSWORD);
            return this;
        }
    }
}