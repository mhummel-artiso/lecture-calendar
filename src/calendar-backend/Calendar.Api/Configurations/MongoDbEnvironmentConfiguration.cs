﻿using Calendar.Api.Models;

namespace Calendar.Api.Configurations
{
    public class MongoDbEnvironmentConfiguration : IEnvironmentConfiguration<MongoDbEnvironmentConfiguration>
    {
        public string MONGODB_SERVER { get; set; } = null!;
        public string MONGODB_DB_NAME { get; set; } = "lecture-calendar";

        /// <inheritdoc/>
        public MongoDbEnvironmentConfiguration Validate()
        {
            new EnvironmentConfigurationValidator()
                .CheckEnvironmentUri(MONGODB_SERVER)
                .CheckEnvironment(MONGODB_DB_NAME);
            return this;
        }
        public string GetConnectionString() => MONGODB_SERVER.EndsWith('/') ? MONGODB_SERVER + MONGODB_DB_NAME : $"{MONGODB_SERVER}/{MONGODB_DB_NAME}";
    }
}