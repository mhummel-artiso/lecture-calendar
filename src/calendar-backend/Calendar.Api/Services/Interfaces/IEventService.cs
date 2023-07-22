using Calendar.Api.Models;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces
{
    public interface IEventService
    {
        Task<CalendarEvent?> GetEventAsync(string calendarId, string eventId);
        Task<IEnumerable<CalendarEvent>?> GetEventsAsync(string calendarId, ViewType viewType, DateTimeOffset date);
        Task<IEnumerable<CalendarEvent>> GetAllEventsFromCalendarAsync(string calendarId);

        Task<CalendarEvent?> AddEventAsync(string calendarId, CalendarEvent calendarEvent);

        Task<CalendarEvent?> UpdateEventAsync(string calendarId, CalendarEvent lectureEvent);

        Task<bool> DeleteEventByIdAsync(string calendarId, string eventId);
    }
}