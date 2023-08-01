using Microsoft.Extensions.Options;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace Calendar.Api.Configurations;

public class ConfigureSwaggerGenOptions : IConfigureOptions<SwaggerGenOptions>
{
    private readonly SwaggerEnvironmentConfiguration swaggerConfig;
    public ConfigureSwaggerGenOptions(IOptions<SwaggerEnvironmentConfiguration> options)
    {
        this.swaggerConfig = options.Value.Validate();
    }

    public void Configure(SwaggerGenOptions options)
    {
        // configure meta data
        options.SwaggerDoc("v1", new OpenApiInfo
        {
            Version = "v1",
            Title = "Calendar Api",
            Description = "Api for calender app",
        });
        const string auth = "oidc";
        // configure security
        options.AddSecurityRequirement(new OpenApiSecurityRequirement()
        {
            {
                new OpenApiSecurityScheme
                {
                    Reference = new OpenApiReference
                    {
                        Type = ReferenceType.SecurityScheme, Id = auth
                    },
                    Scheme = auth,
                    Name = auth,
                    In = ParameterLocation.Header
                },
                new List<string>()
            },
        });
        options.AddSecurityDefinition(auth, new OpenApiSecurityScheme
        {
            Flows =
            {
                Password = new OpenApiOAuthFlow()
                {
                    AuthorizationUrl = swaggerConfig.GetOidcSwaggerAuthorizationUrl(),
                    TokenUrl = swaggerConfig.GetOidcSwaggerTokenUrl(),
                }
            },
            OpenIdConnectUrl = new Uri($"{swaggerConfig.SWAGGER_OIDC_URL}/.well-known/openid-configuration"),
            In = ParameterLocation.Header,
            Type = SecuritySchemeType.OpenIdConnect,
            Description = "OAuht2 Server OpenId Security Scheme",
        });
        // Make sure swagger UI requires a Bearer token to be specified

    }
}