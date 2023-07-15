using Calendar.Api;
using Calendar.Api.Services;
using Calendar.Api.Services.Interfaces;
using MongoDB.Driver;

var builder = WebApplication.CreateBuilder(args);

var configuration = builder.Configuration;
builder.Services.Configure<EnvironmentConfiguration>(configuration);
var environmentConfig = configuration.Get<EnvironmentConfiguration>();

// Env validation
if (environmentConfig == null) throw new ArgumentNullException(nameof(environmentConfig));
if (environmentConfig.MONGODB_CONNECTIONSTRING == null) throw new ArgumentNullException(nameof(environmentConfig.MONGODB_CONNECTIONSTRING));

// Mongo configuration
var mongoClient = new MongoClient(environmentConfig.MONGODB_CONNECTIONSTRING);
var mongoDatabase = mongoClient.GetDatabase(environmentConfig.MONGODB_DB_NAME);
var mongoCalendarsCollection = mongoDatabase.GetCollection<Calendar.Mongo.Db.Models.Calendar>(environmentConfig.MONGODB_CALENDARS_COLLECTION_NAME);

// Add mongo
builder.Services.AddSingleton<IMongoCollection<Calendar.Mongo.Db.Models.Calendar>>(mongoCalendarsCollection);

// Add services to the container.
builder.Services.AddScoped<ICalendarService, CalendarService>();
builder.Services.AddScoped<ILectureService, LectureService>();
builder.Services.AddScoped<IEventService, EventService>();

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
