using Amazon.Runtime.Internal.Transform;
using Calendar.Api.Configurations;
using Calendar.Api.Services;
using Calendar.Api.Services.Interfaces;
using Calendar.PostgreSQL.Db;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using MongoDB.Driver;
using Serilog;
using Swashbuckle.AspNetCore.SwaggerGen;

var builder = WebApplication.CreateBuilder(args);

try
{

    #region Configuration

    var configuration = builder.Configuration;
    builder.Services.AddOptions();
    builder.Services.Configure<MongoDbEnvironmentConfiguration>(configuration);
    builder.Services.Configure<PostgreSqlEnvironmentConfiguration>(configuration);
    builder.Services.Configure<JwtEnvironmentConfiguration>(configuration);
    builder.Services.Configure<OidcEnvironmentConfiguration>(configuration);

    #endregion

    #region Logger

    builder.Host.UseSerilog((ctx, config) =>
        config
            .ReadFrom.Configuration(configuration)
            .Enrich.FromLogContext()
    );

    //builder.Services.AddSerilog();

    #endregion

    #region Mongo db

    var mongoConfig = configuration.Get<MongoDbEnvironmentConfiguration>()?.Validate();
    ArgumentNullException.ThrowIfNull(mongoConfig);
    builder.Services.AddSingleton<IMongoClient>(x =>
    {
        return new MongoClient(mongoConfig.MONGODB_SERVER);
    });
    builder.Services.AddScoped<IMongoDatabase>(x =>
    {
        var client = x.GetRequiredService<IMongoClient>();
        return client.GetDatabase(mongoConfig.MONGODB_DB_NAME);
    });

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

    #region Authentication and authorization

    builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
        .AddJwtBearer(options =>
        {
            var isDebug = builder.Environment.IsDevelopment();
            var jwtConfig = configuration.Get<JwtEnvironmentConfiguration>()?.Validate();
            ArgumentNullException.ThrowIfNull(jwtConfig);
            // see: https://dev.to/kayesislam/integrating-openid-connect-to-your-application-stack-25ch
            options.IncludeErrorDetails = isDebug;
            options.RequireHttpsMetadata = !isDebug;
            options.MetadataAddress = jwtConfig.JWT_METADATA_ADDRESS;
            options.Authority = jwtConfig.JWT_AUTHORITY;
            options.TokenValidationParameters = new()
            {
                ValidAudience = jwtConfig.JWT_AUDIENCE,
                // ValidIssuer = jwtConfig.JWT_ISSUER,
                // IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtConfig.JWT_KEY)),
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = false,
                ValidateIssuerSigningKey = true
            };
        });

    // TODO configure correctly
    builder.Services.AddAuthorization(options =>
    {
        options.DefaultPolicy = new AuthorizationPolicyBuilder()
            .RequireAuthenticatedUser()
            .RequireClaim("roles")
            .Build();
    });

    #endregion

    #region Services and automapper

    builder.Services
        .AddScoped<ICalendarService, CalendarService>()
        .AddScoped<ILectureService, LectureService>()
        .AddScoped<IEventService, EventService>()
        .AddTransient<IConfigureOptions<SwaggerGenOptions>, ConfigureSwaggerGenOptions>()
        .AddSingleton<IKeyGenerator,KeyGenerator>()
        .AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());

    #endregion

    #region Controller

    builder.Services.AddControllers();
    builder.Services.AddHealthChecks();

    #endregion

    #region Swagger

    var swaggerConfig = configuration.Get<OidcEnvironmentConfiguration>()?.Validate();
    ArgumentNullException.ThrowIfNull(swaggerConfig);
    // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen(); // configured by configurator (IConfigureOptions<SwaggerGenOptions>)

    #endregion

    var app = builder.Build();

    // Configure the HTTP request pipeline.
    if (app.Environment.IsDevelopment())
    {
        app.UseSwagger();
        // https://www.camiloterevinto.com/post/oauth-pkce-flow-for-asp-net-core-with-swagger
        app.UseSwaggerUI(options =>
        {
            options.OAuthClientId("calendar-api-swagger");
            options.OAuthClientSecret(swaggerConfig.OIDC_SWAGGER_CLIENT_SECRET);
            options.OAuthScopes("profile", "openid", "roles");
            options.OAuth2RedirectUrl(swaggerConfig.OIDC_SWAGGER_REDIRECT_URL);
            options.OAuthUsePkce();
            options.SwaggerEndpoint("/swagger/v1/swagger.json", "v1");
        });
    }

    app.UseSerilogRequestLogging();
    // app.UseHttpsRedirection();

    app.UseAuthentication();
    app.UseAuthorization();

    app.MapControllers();

    app.Run();
}
catch (ArgumentException ex)
{
    Log.Logger.Error(ex, "Error on startup");
    throw new ArgumentException("Error on startup", ex);
}