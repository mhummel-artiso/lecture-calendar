using Calendar.Api.Models;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces;

public interface ICalendarService
{
    Task<IEnumerable<UserCalendar>> GetCalendarsByNamesAsync(IEnumerable<string> names);
    Task<UserCalendar?> GetCalendarMetadataAsync(string calendarId);
    Task<UserCalendar?> GetCompleteCalendarAsync(string calendarId);

    Task<UserCalendar> AddCalendarAsync(UserCalendar calendar);

    // Warning: Be careful not to delete events.
    Task<UserCalendar?> UpdateCalendarAsync(string calendarId, UserCalendar updateCalendar);

    Task<bool> DeleteCalendarByIdAsync(string calendarId);
}