namespace Calendar.Api.Configurations
{
    public class PostgreSqlEnvironmentConfiguration : IEnvironmentConfiguration<PostgreSqlEnvironmentConfiguration>
    {
        public string? POSTGRESQL_HOST { get; set; } = null;
        public int POSTGRESQL_PORT { get; set; } = 5432;
        public string POSTGRESQL_DATABASE { get; set; } = "CalendarApi";
        public string? POSTGRESQL_USER_NAME { get; set; } = null;
        public string? POSTGRESQL_USER_PASSWORD { get; set; } = null;
        public string GetConnectionString()
        {
            return $"postgresql://{POSTGRESQL_USER_NAME}:{POSTGRESQL_USER_PASSWORD}@{POSTGRESQL_HOST}:{POSTGRESQL_PORT}/{POSTGRESQL_DATABASE}";
            // return $"Host={POSTGRESQL_HOST};Database={POSTGRESQL_DATABASE};Username={POSTGRESQL_USER_NAME};Password={POSTGRESQL_USER_PASSWORD}";
        }

        /// <inheritdoc/>
        public PostgreSqlEnvironmentConfiguration Validate()
        {
            ArgumentException.ThrowIfNullOrEmpty(POSTGRESQL_HOST);
            ArgumentNullException.ThrowIfNull(POSTGRESQL_PORT);
            ArgumentException.ThrowIfNullOrEmpty(POSTGRESQL_DATABASE);
            ArgumentException.ThrowIfNullOrEmpty(POSTGRESQL_USER_NAME);
            ArgumentException.ThrowIfNullOrEmpty(POSTGRESQL_USER_PASSWORD);
            return this;
        }
    }
}