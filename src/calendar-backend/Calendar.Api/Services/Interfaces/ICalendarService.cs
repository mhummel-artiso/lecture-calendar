using Calendar.Api.Models;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces;

public interface ICalendarService
{
    Task<IEnumerable<UserCalendar>> GetCalendarsByNamesAsync(IEnumerable<string> names, bool includeEvents = false);
    Task<UserCalendar?> GetCalendarByIdAsync(string calendarId,bool includeEvents = false);
    
    Task<UserCalendar> AddCalendarAsync(UserCalendar calendar);

    // Warning: Be careful not to delete events.
    Task<UserCalendar?> UpdateCalendarAsync(string calendarId, UserCalendar updateCalendar);

    Task<bool> DeleteCalendarByIdAsync(string calendarId);
    
    Task<IEnumerable<UserCalendar>> GetCalendars();
}