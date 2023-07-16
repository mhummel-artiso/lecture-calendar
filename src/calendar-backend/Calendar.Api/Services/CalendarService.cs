using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using MongoDB.Driver;
using System.Collections.Generic;

namespace Calendar.Api.Services;

public class CalendarService : ICalendarService
{
    private readonly IMongoCollection<Mongo.Db.Models.UserCalendar> calendarCollection;
    private readonly ILogger<ICalendarService> logger;

    public CalendarService(ILogger<ICalendarService> logger, IMongoCollection<UserCalendar> calendarCollection)
    {
        if (logger == null) throw new ArgumentNullException(nameof(logger));
        if (calendarCollection == null) throw new ArgumentNullException(nameof(calendarCollection));

        this.logger = logger;
        this.calendarCollection = calendarCollection;
    }

    public Task AddCalendarAsync(UserCalendar calendar)
    {
        throw new NotImplementedException();
    }

    public Task DeleteCalendarByIdAsync(string id)
    {
        throw new NotImplementedException();
    }

    public Task DeleteCalendarByNameAsync(string calendarName)
    {
        throw new NotImplementedException();
    }

    public Task<UserCalendar> GetCalendarByIdAsync(string id)
    {
        throw new NotImplementedException();
    }

    public Task<UserCalendar> GetCalendarByNameAsync(string name)
    {
        throw new NotImplementedException();
    }

    public Task UpdateClassCalendarAsync(UserCalendar calendar)
    {
        throw new NotImplementedException();
    }


    public async Task <IEnumerable<UserCalendar>> GetAsync() =>
        await calendarCollection.Find(_ => true).ToListAsync();

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