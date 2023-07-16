using Calendar.Mongo.Db.Models;
namespace Calendar.Api.Services.Interfaces;

public interface ICalendarService
{
    Task<UserCalendar> GetCalendarByIdAsync(string id);
    Task<UserCalendar> GetCalendarByNameAsync(string name);

    Task AddCalendarAsync(UserCalendar calendar);

    Task UpdateClassCalendarAsync(UserCalendar calendar);

    Task DeleteCalendarByNameAsync(string calendarName);
    Task DeleteCalendarByIdAsync(string id);

}