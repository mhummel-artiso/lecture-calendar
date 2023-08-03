using Calendar.Api.Models;
using Calendar.Mongo.Db.Models;
using MongoDB.Bson;

namespace Calendar.Api.Services.Interfaces
{
    public interface IEventService
    {
        Task<CalendarEvent> GetEventAsync(string calendarId, string eventId);
        Task<IEnumerable<CalendarEvent>?> GetEventsAsync(string calendarId, ViewType viewType, DateTimeOffset date);
        Task<IEnumerable<CalendarEvent>> GetAllEventsFromCalendarAsync(string calendarId);
        Task<IEnumerable<CalendarEvent>> GetSeriesEventsAsync(string calendarId, ObjectId serieId);

        Task<IEnumerable<CalendarEvent>?> AddEventAsync(string calendarId, CalendarEvent calendarEvent, DateTimeOffset? serieEnd);

        Task<CalendarEvent?> UpdateEventAsync(string calendarId, CalendarEvent lectureEvent);

        Task<bool> DeleteEventByIdAsync(string calendarId, string eventId);
        Task<bool> DeleteEventSerieByIdAsync(string calendarId, string serieId);
    }
}