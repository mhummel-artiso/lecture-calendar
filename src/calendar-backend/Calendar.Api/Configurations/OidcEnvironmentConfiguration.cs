using Calendar.Api.Models;

namespace Calendar.Api.Configurations;

public class OidcEnvironmentConfiguration : IEnvironmentConfiguration<OidcEnvironmentConfiguration>
{
    public string OIDC_URL { get; set; } = "";
    public string OIDC_ROLE_EDITOR { get; set; } = "calendar-editor";
    public string OIDC_ROLE_VIEWER { get; set; } = "calendar-viewer";

    /// <inheritdoc/>
    public OidcEnvironmentConfiguration Validate()
    {
        new EnvironmentConfigurationValidator()
            .CheckEnvironmentUri(OIDC_URL)
            .CheckEnvironment(OIDC_ROLE_EDITOR)
            .CheckEnvironment(OIDC_ROLE_VIEWER);
        return this;
    }
    public OidcEnvironmentConfiguration LogTrace(ILogger logger)
    {
        foreach (var property in GetType().GetProperties())
        {
            logger.LogTrace("{PropName}={PropValue}",property.Name,property.GetValue(this));
        }
        return this;
    }
}