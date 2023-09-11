using Calendar.Api.Models;

namespace Calendar.Api.Configurations;

[Obsolete]
public class JwtEnvironmentConfiguration : IEnvironmentConfiguration<JwtEnvironmentConfiguration>
{
    public string? JWT_AUDIENCE { get; set; } = "http://localhost:8080/realms/calendar";
    public string? JWT_AUTHORITY { get; set; } = "http://localhost:8080/realms/calendar";
    public string JWT_METADATA_ADDRESS { get; set; } = "http://localhost:8080/realms/calendar/.well-known/openid-configuration";
    /// <inheritdoc/>
    public JwtEnvironmentConfiguration Validate()
    {
        new EnvironmentConfigurationValidator()
            .CheckEnvironmentUri(JWT_AUTHORITY)
            .CheckEnvironmentUri(JWT_AUDIENCE)
            .CheckEnvironmentUri(JWT_METADATA_ADDRESS);
        return this;
    }
}