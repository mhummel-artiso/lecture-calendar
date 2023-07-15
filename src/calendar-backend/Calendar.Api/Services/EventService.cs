using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using MongoDB.Driver;

namespace Calendar.Api.Services
{
    public class EventService : IEventService
    {
        private readonly IMongoCollection<Mongo.Db.Models.Calendar> calendarCollection;
        private readonly ILogger<ICalendarService> logger;

        public EventService(ILogger<ICalendarService> logger, IMongoCollection<Mongo.Db.Models.Calendar> calendarCollection)
        {
            if (logger == null) throw new ArgumentNullException(nameof(logger));
            if (calendarCollection == null) throw new ArgumentNullException(nameof(calendarCollection));

            this.logger = logger;
            this.calendarCollection = calendarCollection;
        }

        public async Task AddEventAsync(Event lectureEvent, string calendarId, string lectureId)
        {
            throw new NotImplementedException();
        }

        public async Task DeleteEventByIdAsync(string id)
        {
            throw new NotImplementedException();
        }

        public async Task<Event> GetEventAsync(string calendarName, string lectureId, string id)
        {
            throw new NotImplementedException();
        }

        public async Task UpdateEventAsync(Event lectureEvent, string calendarId, string lectureId)
        {
            throw new NotImplementedException();
        }
    }
}
