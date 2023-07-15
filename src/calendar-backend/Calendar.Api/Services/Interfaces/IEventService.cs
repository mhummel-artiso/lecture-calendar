using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces
{
    public interface IEventService
    {
        Task<Event> GetEventAsync(string calendarName, string lectureId, string id);

        Task AddEventAsync(Event lectureEvent, string calendarId, string lectureId);

        Task UpdateEventAsync(Event lectureEvent, string calendarId, string lectureId);

        Task DeleteEventByIdAsync(string id);
    }
}
