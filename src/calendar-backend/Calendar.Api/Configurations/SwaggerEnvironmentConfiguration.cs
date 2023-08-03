using Calendar.Api.Models;

namespace Calendar.Api.Configurations;

public class DebugEnvironmentConfiguration : IEnvironmentConfiguration<DebugEnvironmentConfiguration>
{
    public bool DEBUG_TEST_ENDPOINT_ENABELD { get; set; } = false;
    public string DEBUG_TEST_ENDPOINT_POLICY { get; set; }
    public DebugEnvironmentConfiguration Validate()
    {
        var validator = new EnvironmentConfigurationValidator()
            .CheckEnvironmentValue(DEBUG_TEST_ENDPOINT_ENABELD);
        if (DEBUG_TEST_ENDPOINT_ENABELD == true)
            validator.CheckEnvironment(DEBUG_TEST_ENDPOINT_POLICY);
        return this;
    }
}

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
            .CheckEnvironment(SWAGGER_OIDC_URL)
            .CheckEnvironment(SWAGGER_REDIRECT_URL)
            .CheckEnvironment(SWAGGER_CLIENT_SECRET)
            .CheckEnvironment(SWAGGER_CLIENT_ID)
            .CheckEnvironment(SWAGGER_AUTHORIZATION_URL)
            .CheckEnvironment(SWAGGER_OIDC_TOKEN_URL);
        return this;
    }
}