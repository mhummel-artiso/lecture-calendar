using Calendar.Api.Models;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces;

public interface ICalendarService
{
    Task<IEnumerable<UserCalendar>> GetCalendarsByNames(IEnumerable<string> names);
    Task<UserCalendar?> GetCalendarMetadata(string calendarId);
    Task<UserCalendar?> GetCompleteCalendar(string calendarId);

    Task<UserCalendar> AddCalendarAsync(UserCalendar calendar);

    // Warning: Be careful not to delete events.
    Task<UserCalendar?> UpdateCalendarAsync(string calendarId, UserCalendar updateCalendar);

    Task<bool> DeleteCalendarByIdAsync(string calendarId);
}