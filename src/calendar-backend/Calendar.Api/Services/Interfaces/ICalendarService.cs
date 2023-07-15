namespace Calendar.Api.Services.Interfaces;

public interface ICalendarService
{
    Task<Mongo.Db.Models.Calendar> GetCalendarByIdAsync(string id);
    Task<Mongo.Db.Models.Calendar> GetCalendarByNameAsync(string name);

    Task AddCalendarAsync(Mongo.Db.Models.Calendar calendar);

    Task UpdateClassCalendarAsync(Mongo.Db.Models.Calendar calendar);

    Task DeleteCalendarByNameAsync(string calendarName);
    Task DeleteCalendarByIdAsync(string id);

}