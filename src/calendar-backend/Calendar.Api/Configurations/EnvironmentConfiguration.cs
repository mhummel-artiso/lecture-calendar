namespace Calendar.Api
{
    public class EnvironmentConfiguration
    {
        public string MONGODB_CONNECTIONSTRING { get; set; } = null!;
        public string MONGODB_DB_NAME { get; set; } = null!;
        public string MONGODB_CALENDARS_COLLECTION_NAME { get; set; } = null!;
        public string MARIADB_CONNECTIONSTRING { get; set; } = null!;
    }
}
