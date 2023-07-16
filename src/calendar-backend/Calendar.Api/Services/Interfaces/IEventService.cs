using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces
{
    public interface IEventService
    {
        Task<CalendarEvent> GetEventAsync(string calendarName, string lectureId, string id);

        Task<IEnumerable<CalendarEvent>> GetAllEventsFromCalendarAsync(string calendarId);

        Task<CalendarEvent> AddEventAsync(CalendarEvent lectureEvent, string calendarId, string lectureId);

        Task UpdateEventAsync(CalendarEvent lectureEvent, string calendarId, string lectureId);

        Task<bool> DeleteEventByIdAsync(string id);
    }
}
