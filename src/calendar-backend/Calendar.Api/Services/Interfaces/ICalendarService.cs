using Calendar.Api.Models;
using Calendar.Mongo.Db.Models;
namespace Calendar.Api.Services.Interfaces;

public interface ICalendarService
{
    // ViewType better in EventService?
    Task<UserCalendar> GetCalendarByIdAsync(string id, ViewType viewType);

    // Maybe: Get only Meta Information?
    Task<UserCalendar> GetCalendarByNameAsync(string name);

    Task<UserCalendar> AddCalendarAsync(UserCalendar calendar);

    // Warning: Be careful not to delete events.
    Task<UserCalendar> UpdateCalendarAsync(string calendarId, UserCalendar calendar);

    Task <bool>DeleteCalendarByIdAsync(string calendarId);

}