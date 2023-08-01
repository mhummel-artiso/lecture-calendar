namespace Calendar.Api.Configurations;

public class SwaggerEnvironmentConfiguration : IEnvironmentConfiguration<SwaggerEnvironmentConfiguration>
{
    public string SWAGGER_OIDC_URL { get; set; } = "";
    public bool USE_SWAGGER { get; set; } = false;

    public string SWAGGER_CLIENT_SECRET { get; set; } = "";
    public string SWAGGER_CLIENT_ID { get; set; } = "calendar-api-swagger";
    public string SWAGGER_REDIRECT_URL { get; set; } = "";
    public string SWAGGER_AUTHORIZATION_URL { get; set; } = "/protocol/openid-connect/auth";
    public string SWAGGER_OIDC_TOKEN_URL { get; set; } = "/protocol/openid-connect/token";
    public string SWAGGER_OIDC_REFRESH_TOKEN_URL { get; set; } = "/protocol/openid-connect/token";
    public Uri GetOidcSwaggerAuthorizationUrl() => new Uri($"{SWAGGER_OIDC_URL.Trim('/')}{SWAGGER_AUTHORIZATION_URL}");
    public Uri GetOidcSwaggerTokenUrl() => new Uri($"{SWAGGER_OIDC_URL.Trim('/')}{SWAGGER_OIDC_TOKEN_URL}");
    public SwaggerEnvironmentConfiguration Validate()
    {
        ArgumentException.ThrowIfNullOrEmpty(SWAGGER_OIDC_URL);
        ArgumentException.ThrowIfNullOrEmpty(SWAGGER_REDIRECT_URL);
        ArgumentException.ThrowIfNullOrEmpty(SWAGGER_CLIENT_SECRET);
        ArgumentException.ThrowIfNullOrEmpty(SWAGGER_CLIENT_ID);
        ArgumentException.ThrowIfNullOrEmpty(SWAGGER_AUTHORIZATION_URL);
        ArgumentException.ThrowIfNullOrEmpty(SWAGGER_OIDC_TOKEN_URL);
        return this;
    }
}

public class OidcEnvironmentConfiguration : IEnvironmentConfiguration<OidcEnvironmentConfiguration>
{

    public string OIDC_ROLE_EDITOR { get; set; } = "calendar-editor";
    public string OIDC_ROLE_VIEWER { get; set; } = "calendar-viewer";

    /// <inheritdoc/>
    public OidcEnvironmentConfiguration Validate()
    {
        ArgumentException.ThrowIfNullOrEmpty(OIDC_ROLE_EDITOR);
        ArgumentException.ThrowIfNullOrEmpty(OIDC_ROLE_VIEWER);
        return this;
    }
}