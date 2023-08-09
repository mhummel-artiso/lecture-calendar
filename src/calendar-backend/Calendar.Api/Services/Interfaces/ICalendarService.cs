using Calendar.Api.Models;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces;

public interface ICalendarService
{
    Task<IEnumerable<UserCalendar>> GetCalendarsByNamesAsync(IEnumerable<string> names);
    Task<UserCalendar?> GetCalendarByIdAsync(string calendarId,bool includeEvents);
    
    Task<UserCalendar> AddCalendarAsync(UserCalendar calendar);

    // Warning: Be careful not to delete events.
    Task<UserCalendar?> UpdateCalendarAsync(string calendarId, UserCalendar updateCalendar);

    Task<bool> DeleteCalendarByIdAsync(string calendarId);

    // FOR TESTING
    Task<IEnumerable<UserCalendar>> GetCalendars();
}