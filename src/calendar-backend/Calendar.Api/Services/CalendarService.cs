using Calendar.Api.Configurations;
using Calendar.Api.Models;
using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using Microsoft.Extensions.Options;
using MongoDB.Driver;
using System.Collections.Generic;

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

    public Task<UserCalendar> AddCalendarAsync(UserCalendar calendar)
    {
        throw new NotImplementedException();
    }

    public Task<bool> DeleteCalendarByIdAsync(string id)
    {
        throw new NotImplementedException();
    }

    public Task<UserCalendar> GetCalendarByIdAsync(string id, ViewType view)
    {
        throw new NotImplementedException();
    }

    public Task<UserCalendar> GetCalendarByNameAsync(string name)
    {
        throw new NotImplementedException();
    }

    public Task<UserCalendar> UpdateCalendarAsync(string id, UserCalendar calendar)
    {
        throw new NotImplementedException();
    }

    public async Task<IEnumerable<UserCalendar>> GetAsync() =>
        await dbCollection.Find(_ => true).ToListAsync();

    //public async Task<Book?> GetAsync(string id) =>
    //    await calendarCollection.Find(x => x.Id == id).FirstOrDefaultAsync();

    //public async Task CreateAsync(Book newBook) =>
    //    await calendarCollection.InsertOneAsync(newBook);

    //public async Task UpdateAsync(string id, Book updatedBook) =>
    //    await calendarCollection.ReplaceOneAsync(x => x.Id == id, updatedBook);

    //public async Task RemoveAsync(string id) =>
    //    await calendarCollection.DeleteOneAsync(x => x.Id == id);

    //public async Task<bool> CreateCalendar(Mongo.Db.Models.Calendar classCalendar)
    //{

    //    await calendarCollection.InsertOneAsync(classCalendar);
    //    return true;
    //}
    //public CalendarItem GetCalendar(Guid studentClass) => throw new NotImplementedException();
}