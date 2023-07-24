using Microsoft.Extensions.Options;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace Calendar.Api.Configurations;

public class ConfigureSwaggerGenOptions : IConfigureOptions<SwaggerGenOptions>
{
    private readonly OidcEnvironmentConfiguration swaggerConfig;
    public ConfigureSwaggerGenOptions(IOptions<OidcEnvironmentConfiguration> options)
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
        // configure security
        //options.AddSecurityDefinition("jwt_auth", new OpenApiSecurityScheme()
        //{
        //    Name = "Authorization",
        //    BearerFormat = "JWT",
        //    Flows = new OpenApiOAuthFlows
        //    {
        //        Password = new OpenApiOAuthFlow()
        //        {
        //            AuthorizationUrl = new Uri(swaggerConfig.OIDC_SWAGGER_AUTHORIZATION_URL),
        //            TokenUrl = new Uri(swaggerConfig.OIDC_SWAGGER_TOKEN_URL),
        //        }
        //    },
        //    Scheme = "bearer",
        //    Description = "Specify the authorization token.",
        //});
        options.AddSecurityDefinition("OAuth2", new OpenApiSecurityScheme
        {
            Flows = new OpenApiOAuthFlows
            {
                // redirect to auht server
                AuthorizationCode = new OpenApiOAuthFlow
                {
                    AuthorizationUrl = new Uri(swaggerConfig.GetOidcSwaggerAuthorizationUrl()),
                    TokenUrl = new Uri(swaggerConfig.GetOidcSwaggerTokenUrl()),
                },
                // use login UI from swagger
                Password = new OpenApiOAuthFlow
                {
                    AuthorizationUrl = new Uri(swaggerConfig.GetOidcSwaggerAuthorizationUrl()),
                    TokenUrl = new Uri(swaggerConfig.GetOidcSwaggerTokenUrl()),
                }
            },
            OpenIdConnectUrl = new Uri($"{swaggerConfig.OIDC_URL}/.well-known/openid-configuration"),
            In = ParameterLocation.Header,
            Type = SecuritySchemeType.OAuth2,
            Description = "OAuht2 Server OpenId Security Scheme"
        });
        // Make sure swagger UI requires a Bearer token to be specified
        options.AddSecurityRequirement(new OpenApiSecurityRequirement()
        {
            {
                new OpenApiSecurityScheme
                {
                    Reference = new OpenApiReference
                    {
                        Type = ReferenceType.SecurityScheme,
                        Id = "bearer",
                    },
                }, Array.Empty<string>()
            },
        });
    }
}
