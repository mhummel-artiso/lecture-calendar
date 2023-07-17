namespace Calendar.Api.Configurations
{
    public class MongoDbEnvironmentConfiguration
    {
        public string MONGODB_CONNECTIONSTRING { get; set; } = null!;
        public string MONGODB_DB_NAME { get; set; } = null!;
        public string MONGODB_CALENDARS_COLLECTION_NAME { get; set; } = null!;

    }
}