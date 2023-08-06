using Amazon.Runtime.Internal.Transform;
using Calendar.Api.Configurations;
using Calendar.Api.Initializations;
using Calendar.Api.Models;
using Calendar.Api.Services;
using Calendar.Api.Services.Interfaces;
using Calendar.PostgreSQL.Db;
using Keycloak.AuthServices.Authentication;
using Keycloak.AuthServices.Authorization;
using Keycloak.AuthServices.Sdk.Admin;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Logging;
using MongoDB.Bson;
using MongoDB.Driver;
using Newtonsoft.Json;
using Serilog;
using Serilog.Enrichers.AspNetCore;
using Serilog.Exceptions;
using Swashbuckle.AspNetCore.SwaggerGen;
using System.Security.Claims;

var builder = WebApplication.CreateBuilder(args);

try
{

    #region Configuration

    IdentityModelEventSource.ShowPII = true;

    var configuration = builder.Configuration;
    configuration.AddEnvironmentVariables(prefix: "API_");
    builder.Services.AddOptions();
    builder.Services.Configure<MongoDbEnvironmentConfiguration>(configuration);
    builder.Services.Configure<PostgreSqlEnvironmentConfiguration>(configuration);
    builder.Services.Configure<JwtEnvironmentConfiguration>(configuration);
    builder.Services.Configure<OidcEnvironmentConfiguration>(configuration);
    builder.Services.Configure<SwaggerEnvironmentConfiguration>(configuration);

    #endregion

    #region Logger

    builder.Host.UseSerilog((ctx, config) =>
        config
            .ReadFrom.Configuration(configuration)
            .Enrich.FromLogContext()
            .Enrich.WithEnvironmentName()
            .Enrich.WithExceptionDetails()
            .Enrich.WithMachineName()
    );

    #endregion
    
    #region Mongo db

    var mongoConfig = configuration.Get<MongoDbEnvironmentConfiguration>()?.Validate();
    ArgumentNullException.ThrowIfNull(mongoConfig);
    builder.Services.AddSingleton<IMongoClient>(x =>
        new MongoClient(mongoConfig.MONGODB_SERVER));
    builder.Services.AddScoped<IMongoDatabase>(x =>
        x.GetRequiredService<IMongoClient>()
            .GetDatabase(mongoConfig.MONGODB_DB_NAME));

    #endregion

    #region PostgreSQL db

    // https://learn.microsoft.com/en-us/aspnet/core/security/data-protection/configuration/overview?view=aspnetcore-3.1
    // builder.Services.AddDbContext<PersistKeyContext>(options =>
    // {
    //     var postgresqlConfig = configuration.Get<PostgreSqlEnvironmentConfiguration>()?.Validate();
    //     ArgumentNullException.ThrowIfNull(postgresqlConfig);
    //     var str = postgresqlConfig.GetConnectionString();
    //     options.UseNpgsql(str);
    // });
    //
    // builder.Services
    //     .AddDataProtection()
    //     .PersistKeysToDbContext<PersistKeyContext>();

    #endregion

    #region Swagger

    var swaggerConfig = configuration.Get<SwaggerEnvironmentConfiguration>()?.Validate();
    ArgumentNullException.ThrowIfNull(swaggerConfig);
    // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
    builder.Services
        .AddEndpointsApiExplorer()
        .AddSwaggerGen(); // configured by configurator (IConfigureOptions<SwaggerGenOptions>)

    #endregion

    #region Authentication and authorization

    builder.Services.AddKeycloakAuthentication(configuration);

    // TODO configure correctly
    builder.Services.AddAuthorization(options =>
    {
        var oidcConfig = configuration.Get<OidcEnvironmentConfiguration>()?.Validate();
        ArgumentNullException.ThrowIfNull(oidcConfig);
        var roleViewer = oidcConfig.OIDC_ROLE_VIEWER;
        var roleEditor = oidcConfig.OIDC_ROLE_EDITOR;
        options.AddPolicy(AuthPolicies.VIEWER, p =>
            p.RequireRealmRoles(roleViewer)
                .RequireRole(roleViewer));
        options.AddPolicy(AuthPolicies.EDITOR, p =>
            p.RequireRealmRoles(roleEditor)
                .RequireRole(roleEditor));
        options.AddPolicy(AuthPolicies.EDITOR_VIEWER, p =>
            p.RequireRealmRoles(roleEditor, roleViewer)
                .RequireRole(roleEditor, roleViewer));
        // test policy
        options.AddPolicy("IsAdmin", b =>
        {
            b.RequireRealmRoles("admin")
                .RequireRole("admin");
        });
    }).AddKeycloakAuthorization(configuration);

    #endregion

    #region Services and automapper

    builder.Services
        .AddSingleton<IKeyGenerator, KeyGenerator>()
        .AddScoped<ICalendarService, CalendarService>()
        .AddScoped<ILectureService, LectureService>()
        .AddScoped<IEventService, EventService>()
        .AddTransient<IConfigureOptions<SwaggerGenOptions>, InitializeSwaggerGenOptions>()
        .AddTransient<IKeycloakService, KeycloakService>()
        .AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies())
        .AddKeycloakAdminHttpClient(configuration);

    #endregion

    #region Controller

    builder.Services.AddControllers();
    builder.Services.AddHealthChecks();

    #endregion

    var app = builder.Build();

    app.UseHttpLogging();
    // app.UseW3CLogging();

    // Configure the HTTP request pipeline.
    if (swaggerConfig.USE_SWAGGER)
    {
        // https://www.camiloterevinto.com/post/oauth-pkce-flow-for-asp-net-core-with-swagger
        app.UseSwagger()
            .UseSwaggerUI(options =>
            {
                options.SwaggerEndpoint("/swagger/v1/swagger.json", "v1");
                options.OAuthClientId(swaggerConfig.SWAGGER_CLIENT_ID);
                options.OAuthClientSecret(swaggerConfig.SWAGGER_CLIENT_SECRET);
                options.OAuth2RedirectUrl(swaggerConfig.SWAGGER_REDIRECT_URL);
                options.OAuthScopes("profile", "openid", "roles");
                options.OAuthUseBasicAuthenticationWithAccessCodeGrant();
            });
    }

    app.UseSerilogRequestLogging();

    app.UseCors(c => c.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
    app.UseAuthentication();
    app.UseAuthorization();
    app.MapControllers();
    // if (app.Environment.IsDevelopment())
    var debugConf = configuration.Get<DebugEnvironmentConfiguration>()?.Validate();
    ArgumentNullException.ThrowIfNull(debugConf);
    if (debugConf.DEBUG_TEST_ENDPOINT_ENABLED)
    {
        app.MapGet("test", (ClaimsPrincipal user) =>
        {
            app.Logger.LogInformation(user.Identity?.Name);
            return user.Identity?.Name ?? "NULL";
        }).RequireAuthorization(debugConf.DEBUG_TEST_ENDPOINT_POLICY);
    }
    app.Run();
}
catch (ArgumentException ex)
{
    Log.Logger.Error(ex, "Error on startup");
    throw new ArgumentException("Error on startup", ex);
}