using Calendar.Api.Models;
using Calendar.Mongo.Db.Models;
namespace Calendar.Api.Services.Interfaces;

public interface ICalendarService
{
    Task<Dictionary<string, string>> GetCalendarIdsByNames(IEnumerable<string> name);
    Task<UserCalendar> GetCalendarMetadata(string calendarId);
    Task<UserCalendar> GetCompleteCalendar(string calendarId);

    Task<UserCalendar> AddCalendarAsync(UserCalendar calendar);

    // Warning: Be careful not to delete events.
    Task<UserCalendar> UpdateCalendarAsync(string calendarId, UserCalendar calendar);

    Task <bool>DeleteCalendarByIdAsync(string calendarId);
}