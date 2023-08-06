using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using MongoDB.Bson;
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
    public async Task<UserCalendar?> GetCalendarByIdAsync(string calendarId, bool includeEvents)
    {
        var query = dbCollection
            .Find(x => x.Id == new ObjectId(calendarId));
        if (!includeEvents)
            query = query
                .Project<UserCalendar>(
                    Builders<UserCalendar>.Projection
                        .Exclude(x => x.Events));
        return await query.FirstOrDefaultAsync();
    }
    public async Task<UserCalendar> AddCalendarAsync(UserCalendar calendar)
    {
        var existed = await dbCollection
            .Find(x =>
                string.Equals(calendar.Name, x.Name, StringComparison.OrdinalIgnoreCase))
            .FirstOrDefaultAsync();
        if (existed != null)
            throw new ApplicationException($"the calendar with the name {calendar.Name} already exists");
        calendar.CreatedDate = DateTimeOffset.UtcNow;
        calendar.LastUpdateDate = DateTimeOffset.UtcNow;
        await dbCollection.InsertOneAsync(calendar);
        return calendar;
    }
    public async Task<UserCalendar?> UpdateCalendarAsync(string calendarId, UserCalendar updateCalendar)
    {
        var updates = new UpdateDefinitionBuilder<UserCalendar>()
            .Set(x => x.Name, updateCalendar.Name)
            .Set(x => x.StartDate, updateCalendar.StartDate)
            .Set(x => x.LastUpdateDate, DateTimeOffset.UtcNow);
        var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(calendarId), updates);
        return result.ModifiedCount == 1
            ? await dbCollection
                .Find(x => x.Id == new ObjectId(calendarId))
                .FirstOrDefaultAsync()
            : null;
    }
    public async Task<bool> DeleteCalendarByIdAsync(string calendarId)
    {
        var result = await dbCollection.DeleteOneAsync(x => x.Id == new ObjectId(calendarId));
        return result.DeletedCount == 1;
    }

    // FOR TESTING, later use GetCalendarsByNamesAsync
    public async Task<IEnumerable<UserCalendar>> GetCalendars()
    {
        return await dbCollection.Find(x => true).Project<UserCalendar>(Builders<UserCalendar>.Projection.Exclude(x => x.Events)).ToListAsync();
    }
}