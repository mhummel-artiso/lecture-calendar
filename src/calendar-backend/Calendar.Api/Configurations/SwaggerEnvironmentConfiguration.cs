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

    public SwaggerEnvironmentConfiguration LogDebugValues(ILogger logger)
    {
        logger.LogDebug("SWAGGER_OIDC_URL={SwaggerOidcUrl}", SWAGGER_OIDC_URL);
        logger.LogDebug("SWAGGER_CLIENT_SECRET={SwaggerClientSecret}", SWAGGER_CLIENT_SECRET);
        logger.LogDebug("SWAGGER_REDIRECT_URL={SwaggerRedirectUrl}", SWAGGER_REDIRECT_URL);
        logger.LogDebug("SWAGGER_CLIENT_ID={SwaggerClientID}", SWAGGER_CLIENT_ID);
        logger.LogDebug("SWAGGER_AUTHORIZATION_URL={SwaggerAuthorizationUrl}", SWAGGER_AUTHORIZATION_URL);
        logger.LogDebug("SWAGGER_OIDC_TOKEN_URL={SwaggerOidcTokenUrl}", SWAGGER_OIDC_TOKEN_URL);
        logger.LogDebug("SWAGGER_OIDC_REFRESH_TOKEN_URL={SwaggerOidcRefreshTokenUrl}", SWAGGER_OIDC_REFRESH_TOKEN_URL);

        return this;
    }
}