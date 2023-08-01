namespace Calendar.Api.Configurations;

public class OidcEnvironmentConfiguration : IEnvironmentConfiguration<OidcEnvironmentConfiguration>
{
    public string OIDC_URL { get; set; } = "";
    public string OIDC_ROLE_EDITOR { get; set; } = "calendar-editor";
    public string OIDC_ROLE_VIEWER { get; set; } = "calendar-viewer";

    /// <inheritdoc/>
    public OidcEnvironmentConfiguration Validate()
    {
        ArgumentException.ThrowIfNullOrEmpty(OIDC_URL);
        ArgumentException.ThrowIfNullOrEmpty(OIDC_ROLE_EDITOR);
        ArgumentException.ThrowIfNullOrEmpty(OIDC_ROLE_VIEWER);
        return this;
    }
}