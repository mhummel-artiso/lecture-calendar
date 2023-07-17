using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using MongoDB.Driver;

namespace Calendar.Api.Services
{
    public class EventService : IEventService
    {
        private readonly IMongoCollection<UserCalendar> dbCollection;
        private readonly ILogger<ICalendarService> logger;

        public EventService(ILogger<ICalendarService> logger, IMongoDatabase db)
        {
            this.logger = logger;
            dbCollection = db.GetCollection<UserCalendar>(nameof(UserCalendar));
            ArgumentNullException.ThrowIfNull(dbCollection);
        }


        public async Task<CalendarEvent> GetEventAsync(string calendarName, string lectureId, string id) => throw new NotImplementedException();
        public async Task<IEnumerable<CalendarEvent>> GetAllEventsFromCalendarAsync(string calendarId) => throw new NotImplementedException();
        public async Task<CalendarEvent> AddEventAsync(CalendarEvent lectureEvent, string calendarId, string lectureId) => throw new NotImplementedException();
        public async Task UpdateEventAsync(CalendarEvent lectureEvent, string calendarId, string lectureId) => throw new NotImplementedException();
        public async Task<bool> DeleteEventByIdAsync(string id) => throw new NotImplementedException();
    }
}