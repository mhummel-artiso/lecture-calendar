using Amazon.Runtime.Internal.Transform;
using Calendar.Api.Configurations;
using Calendar.Api.HealthChecks;
using Calendar.Api.Initializations;
using Calendar.Api.Models;
using Calendar.Api.Services;
using Calendar.Api.Services.Interfaces;
using FS.Keycloak.RestApiClient.Client;
using Keycloak.AuthServices.Authentication;
using Keycloak.AuthServices.Authorization;
using Keycloak.AuthServices.Sdk.Admin;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Logging;
using MongoDB.Bson;
using MongoDB.Driver;
using Newtonsoft.Json;
using Prometheus;
using Prometheus.SystemMetrics;
using Serilog;
using Serilog.AspNetCore;
using Serilog.Enrichers.AspNetCore;
using Serilog.Events;
using Serilog.Exceptions;
using Swashbuckle.AspNetCore.SwaggerGen;
using System.Security.Claims;

try
{

    #region Configure Services

    var builder = WebApplication.CreateBuilder(args);

    #region Configuration

    IdentityModelEventSource.ShowPII = true;

    var configuration = builder.Configuration;
    configuration.AddEnvironmentVariables(prefix: "API_");
    builder.Services.AddOptions();
    builder.Services.Configure<MongoDbEnvironmentConfiguration>(configuration);
    // builder.Services.Configure<PostgreSqlEnvironmentConfiguration>(configuration);
    builder.Services.Configure<OidcEnvironmentConfiguration>(configuration);
    builder.Services.Configure<SwaggerEnvironmentConfiguration>(configuration);
    builder.Services.Configure<KeycloakRestEnvironmentConfiguration>(configuration);

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
    var oidcConfig = configuration.Get<OidcEnvironmentConfiguration>()?.Validate();
    builder.Services.AddAuthorization(options =>
    {
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
    }).AddKeycloakAuthorization(configuration);

    #endregion

    #region Services and automapper

    builder.Services
        .AddSystemMetrics()
        .AddScoped<ICalendarService, CalendarService>()
        .AddScoped<ILectureService, LectureService>()
        .AddScoped<IEventService, EventService>()
        .AddTransient<IConfigureOptions<SwaggerGenOptions>, InitializeSwaggerGenOptions>()
        .AddTransient<IKeycloakService, KeycloakService>()
        .AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies())
        .AddHttpClient();

    #endregion

    #region Controller

    builder.Services.AddControllers();

    #endregion

    #region Health Checks

    builder.Services.AddHealthChecks()
        .AddMongoDb(
            mongoConfig.MONGODB_SERVER,
            mongoConfig.MONGODB_DB_NAME,
            HealthStatus.Unhealthy)
        .AddCheck<KeyCloakHealthCheck>(KeyCloakHealthCheck.Name);

    #endregion

    #region Keycloak Rest

    var keycloakRestConfig = configuration.Get<KeycloakRestEnvironmentConfiguration>()?.Validate();
    if (keycloakRestConfig != null)
    {
        builder.Services.AddSingleton(new KeycloakHttpClient(
            keycloakRestConfig!.KEYCLOAK_BASE_URL,
            keycloakRestConfig!.KEYCLOAK_REST_USER,
            keycloakRestConfig!.KEYCLOAK_REST_PASSWORD));
    }

    #endregion

    #endregion

    #region configure App

    var app = builder.Build();

    mongoConfig?.LogTrace(app.Logger);
    swaggerConfig?.LogTrace(app.Logger);
    oidcConfig?.LogTrace(app.Logger);
    keycloakRestConfig?.LogTrace(app.Logger);

    #region Swagger

    if (swaggerConfig?.USE_SWAGGER == true)
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

    #endregion

    // Configure the HTTP request pipeline.

    #region Logging

    app.UseSerilogRequestLogging(o =>
    {
        o.IncludeQueryInRequestPath = true;
        o.GetLevel = (ctx, _, ex) =>
        {
            if (ex != null)
                return LogEventLevel.Error;
            return ctx.Response.StatusCode switch
            {
                < 400 => LogEventLevel.Debug,
                <= 499 => LogEventLevel.Information,
                _ => LogEventLevel.Error,
            };
        };
    });

    #endregion

    #region Access controll

    app.UseCors(c => c
        .AllowAnyOrigin()
        .AllowAnyMethod()
        .AllowAnyHeader());
    app.UseAuthentication();
    app.UseAuthorization();

    #endregion

    #region endpoints

    app.MapControllers();

    #endregion

    #region Health check

    app.MapHealthChecks("v1/api/health");
    app.UseHealthChecksPrometheusExporter("/metrics")
        .UseHttpMetrics()
        .UseMetricServer();

    #endregion

    #region Test endpoint

    var debugConf = configuration
        .Get<DebugEnvironmentConfiguration>()?.Validate()
        .LogTrace(app.Logger);
    ArgumentNullException.ThrowIfNull(debugConf);
    if (debugConf.DEBUG_TEST_ENDPOINT_ENABLED)
    {
        app.MapGet("test", (ClaimsPrincipal user) =>
        {
            app.Logger.LogInformation(user.Identity?.Name);
            return user.Identity?.Name ?? "NULL";
        }).RequireAuthorization(debugConf.DEBUG_TEST_ENDPOINT_POLICY);
    }

    #endregion

    app.Run();

    #endregion

}
catch (ArgumentException ex)
{
    Log.Logger.Error(ex, "Error on startup");
    throw new ArgumentException("Error on startup", ex);
}
catch (Exception ex)
{
    Log.Logger.Error(ex, "Error on startup");
    throw new ApplicationException("Error on startup", ex);
}