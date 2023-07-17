using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces
{
    public interface IEventService
    {
        Task<CalendarEvent> GetEventAsync(string calendarId, string eventId);
        Task<IEnumerable<CalendarEvent>> GetEventsFromDayAsync(string calendarId, DateTime date);
        Task<IEnumerable<CalendarEvent>> GetEventsFromWeekAsync(string calendarId, DateTime date);
        Task<IEnumerable<CalendarEvent>> GetEventsFromMonthAsync(string calendarId, DateTime date);
        Task<IEnumerable<CalendarEvent>> GetAllEventsFromCalendarAsync(string calendarId);

        Task<CalendarEvent> AddEventAsync(CalendarEvent lectureEvent, string calendarId);

        Task UpdateEventAsync(CalendarEvent lectureEvent, string calendarId);

        Task<bool> DeleteEventByIdAsync(string calendarId, string eventId);
    }
}
