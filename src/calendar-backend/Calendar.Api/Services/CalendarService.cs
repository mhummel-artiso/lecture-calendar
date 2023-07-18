using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using MongoDB.Driver;

namespace Calendar.Api.Services;

public class CalendarService : ICalendarService
{
    private readonly IMongoCollection<UserCalendar> dbCollection;
    private readonly ILogger<ICalendarService> logger;

    public CalendarService(ILogger<ICalendarService> logger, IMongoDatabase db)
    {
        this.logger = logger;
        dbCollection = db.GetCollection<UserCalendar>(nameof(UserCalendar));
        ArgumentNullException.ThrowIfNull(dbCollection);
    }

    public async Task<IEnumerable<UserCalendar>> GetCalendarsByNamesAsync(IEnumerable<string> names)
    {
        var keys = names.ToList();
        var result = await dbCollection.Find(x => keys.Contains(x.Name)).Project<UserCalendar>(Builders<UserCalendar>.Projection.Exclude(x => x.Events)).ToListAsync();
        return result;
    }
    public async Task<UserCalendar?> GetCalendarById(string calendarId, bool includeEvents)
    {
        var query = dbCollection
            .Find(x => x.Id == calendarId);
        if (!includeEvents)
            query = query
                .Project<UserCalendar>(
                    Builders<UserCalendar>.Projection
                        .Exclude(x => x.Events));
        return await query.FirstOrDefaultAsync();
    }
    public async Task<UserCalendar> AddCalendarAsync(UserCalendar calendar)
    {
        await dbCollection.InsertOneAsync(calendar);
        return calendar;
    }
    public async Task<UserCalendar?> UpdateCalendarAsync(string calendarId, UserCalendar updateCalendar)
    {
        var updates = new UpdateDefinitionBuilder<UserCalendar>()
            .Set(x => x.Name, updateCalendar.Name)
            .Set(x => x.StartDate, updateCalendar.StartDate);
        var result = await dbCollection.UpdateOneAsync(x => x.Id == calendarId, updates);
        return result.IsAcknowledged ? updateCalendar : null;
    }
    public async Task<bool> DeleteCalendarByIdAsync(string calendarId)
    {
        var result = await dbCollection.DeleteOneAsync(x => x.Id == calendarId);
        return result.DeletedCount == 1;
    }
}