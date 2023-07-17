using Calendar.Api.Configurations;
using Calendar.Api.Services;
using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using MongoDB.Driver;

var builder = WebApplication.CreateBuilder(args);

var configuration = builder.Configuration;
builder.Services.Configure<MongoDbEnvironmentConfiguration>(configuration);
var environmentConfig = configuration.Get<MongoDbEnvironmentConfiguration>();

// Env validation
if (environmentConfig == null) throw new ArgumentNullException(nameof(environmentConfig));
if (environmentConfig.MONGODB_CONNECTIONSTRING == null) throw new ArgumentNullException(nameof(environmentConfig.MONGODB_CONNECTIONSTRING));

// Mongo configuration
builder.Services.AddScoped<IMongoClient>(x => new MongoClient(environmentConfig.MONGODB_CONNECTIONSTRING));
builder.Services.AddScoped<IMongoDatabase>(x =>
{
    var client = x.GetRequiredService<IMongoClient>();
    return client.GetDatabase(environmentConfig.MONGODB_DB_NAME);
});

// Add services to the container.
builder.Services.AddScoped<ICalendarService, CalendarService>();
builder.Services.AddScoped<ILectureService, LectureService>();
builder.Services.AddScoped<IEventService, EventService>();

// Add automapper
builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();