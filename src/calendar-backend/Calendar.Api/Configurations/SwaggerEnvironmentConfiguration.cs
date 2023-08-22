using Calendar.Api.Models;

namespace Calendar.Api.Configurations;

public class SwaggerEnvironmentConfiguration : IEnvironmentConfiguration<SwaggerEnvironmentConfiguration>
{
    public bool USE_SWAGGER { get; set; } = false;
    public string SWAGGER_OIDC_URL { get; set; } = "";
    public string SWAGGER_CLIENT_SECRET { get; set; } = "";
    public string SWAGGER_REDIRECT_URL { get; set; } = "";
    public string SWAGGER_CLIENT_ID { get; set; } = "calendar-api-swagger";
    public string SWAGGER_AUTHORIZATION_URL { get; set; } = "/protocol/openid-connect/auth";
    public string SWAGGER_OIDC_TOKEN_URL { get; set; } = "/protocol/openid-connect/token";
    public string SWAGGER_OIDC_REFRESH_TOKEN_URL { get; set; } = "/protocol/openid-connect/token";
    private const char urlSeperator = '/';
    public Uri GetOidcSwaggerAuthorizationUrl() => new($"{SWAGGER_OIDC_URL.TrimEnd('/')}/{SWAGGER_AUTHORIZATION_URL.TrimStart('/')}");
    public Uri GetOidcSwaggerTokenUrl() => new($"{SWAGGER_OIDC_URL.TrimEnd('/')}/{SWAGGER_OIDC_TOKEN_URL.TrimStart('/')}");
    public SwaggerEnvironmentConfiguration Validate()
    {
        new EnvironmentConfigurationValidator()
            .CheckEnvironmentUri(SWAGGER_OIDC_URL)
            .CheckEnvironmentUri(SWAGGER_REDIRECT_URL)
            .CheckEnvironment(SWAGGER_CLIENT_SECRET)
            .CheckEnvironment(SWAGGER_CLIENT_ID)
            .CheckEnvironmentUri(SWAGGER_AUTHORIZATION_URL, true)
            .CheckEnvironmentUri(SWAGGER_OIDC_TOKEN_URL, true);
        return this;
    }
}