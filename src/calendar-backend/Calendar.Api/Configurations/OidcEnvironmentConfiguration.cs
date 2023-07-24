namespace Calendar.Api.Configurations;

public class OidcEnvironmentConfiguration : IEnvironmentConfiguration<OidcEnvironmentConfiguration>
{
    public string OIDC_URL { get; set; } = "";
    public string OIDC_SWAGGER_CLIENT_SECRET { get; set; } = "";
    public string OIDC_SWAGGER_REDIRECT_URL { get; set; } = "";

    public string OIDC_SWAGGER_AUTHORIZATION_URL { get; set; } = "/protocol/openid-connect/auth";
    public string GetOidcSwaggerAuthorizationUrl() => $"{OIDC_URL.Trim('/')}{OIDC_SWAGGER_AUTHORIZATION_URL}";
    public string OIDC_SWAGGER_TOKEN_URL { get; set; } = "/protocol/openid-connect/token";
    public string GetOidcSwaggerTokenUrl() => $"{OIDC_URL.Trim('/')}{OIDC_SWAGGER_TOKEN_URL}";


    /// <inheritdoc/>
    public OidcEnvironmentConfiguration Validate()
    {
        ArgumentException.ThrowIfNullOrEmpty(OIDC_URL);
        ArgumentException.ThrowIfNullOrEmpty(OIDC_SWAGGER_REDIRECT_URL);
        ArgumentException.ThrowIfNullOrEmpty(OIDC_SWAGGER_CLIENT_SECRET);
        ArgumentException.ThrowIfNullOrEmpty(OIDC_SWAGGER_AUTHORIZATION_URL);
        ArgumentException.ThrowIfNullOrEmpty(OIDC_SWAGGER_TOKEN_URL);

        return this;
    }
}