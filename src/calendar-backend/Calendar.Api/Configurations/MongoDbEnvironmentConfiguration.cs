namespace Calendar.Api.Configurations
{
    public class MongoDbEnvironmentConfiguration : IEnvironmentConfiguration<MongoDbEnvironmentConfiguration>
    {
        public string MONGODB_SERVER { get; set; } = null!;
        public string MONGODB_DB_NAME { get; set; } = "lecture-calendar";
        
        /// <inheritdoc/>
        public MongoDbEnvironmentConfiguration Validate()
        {
            ArgumentException.ThrowIfNullOrEmpty(MONGODB_SERVER);
            ArgumentException.ThrowIfNullOrEmpty(MONGODB_DB_NAME);
            return this;
        }
    }
}