namespace Calendar.Api.Configurations;
public class JwtEnvironmentConfiguration : IEnvironmentConfiguration<JwtEnvironmentConfiguration>
{
    [Obsolete]
    public string? JWT_ISSUER { get; set; }
    public string? JWT_AUDIENCE { get; set; } = "http://localhost:8080/realms/calendar";
    public string? JWT_AUTHORITY { get; set; } = "http://localhost:8080/realms/calendar";
    [Obsolete]
    public string JWT_KEY { get; set; }
    public string JWT_METADATA_ADDRESS { get; set; } = "http://localhost:8080/realms/calendar/.well-known/openid-configuration";
    /// <inheritdoc/>
    public JwtEnvironmentConfiguration Validate()
    {
        ArgumentException.ThrowIfNullOrEmpty(JWT_AUTHORITY);

        return this;
    }
}