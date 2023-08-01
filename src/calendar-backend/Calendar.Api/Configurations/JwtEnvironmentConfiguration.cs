﻿using Calendar.Api.Models;

namespace Calendar.Api.Configurations;

public class JwtEnvironmentConfiguration : IEnvironmentConfiguration<JwtEnvironmentConfiguration>
{
    public string? JWT_AUDIENCE { get; set; } = "http://localhost:8080/realms/calendar";
    public string? JWT_AUTHORITY { get; set; } = "http://localhost:8080/realms/calendar";
    public string JWT_METADATA_ADDRESS { get; set; } = "http://localhost:8080/realms/calendar/.well-known/openid-configuration";
    [Obsolete]
    public string? JWT_ISSUER { get; set; }
    [Obsolete]
    public string JWT_KEY { get; set; }
    /// <inheritdoc/>
    public JwtEnvironmentConfiguration Validate()
    {
        new EnvironmentConfigurationValidator()
            .CheckEnvironment(JWT_AUTHORITY)
            .CheckEnvironment(JWT_AUDIENCE)
            .CheckEnvironment(JWT_METADATA_ADDRESS);
        return this;
    }
}