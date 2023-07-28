using Calendar.Api.Models;
using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using MongoDB.Bson;
using MongoDB.Driver;
using MongoDB.Driver.Linq;
using System.Linq.Expressions;

namespace Calendar.Api.Services
{
    public class EventService : IEventService
    {
        private readonly IMongoCollection<UserCalendar> dbCollection;
        private readonly ILogger<ICalendarService> logger;
        private readonly IKeyGenerator keyGenerator;

        public EventService(ILogger<ICalendarService> logger, IMongoDatabase db, IKeyGenerator keyGenerator)
        {
            this.logger = logger;
            this.keyGenerator = keyGenerator;
            dbCollection = db.GetCollection<UserCalendar>(nameof(UserCalendar));
            ArgumentNullException.ThrowIfNull(dbCollection);
        }
        public async Task<CalendarEvent?> GetEventAsync(string calendarId, string eventId)
        {
            var result = await dbCollection.Find(x => x.Id == new ObjectId(calendarId)).FirstOrDefaultAsync();
            return result?.Events?.FirstOrDefault(x => x.Id == new ObjectId(eventId));
        }
        public async Task<IEnumerable<CalendarEvent>?> GetEventsAsync(string calendarId, ViewType viewType, DateTimeOffset date)
        {
            var result = await dbCollection
                .Find(x => x.Id == new ObjectId(calendarId))
                .FirstOrDefaultAsync();
            if (result == null)
                return null; // null if calendar not exists
            var startDate = date.AddDays(-(int)date.DayOfWeek);
            var endDate = viewType switch
            {
                ViewType.Day => startDate.AddDays(1),
                ViewType.Week => startDate.AddDays(5),
                ViewType.Month => startDate.AddMonths(1),
                _ => throw new ArgumentOutOfRangeException(nameof(viewType)),
            };
            return result.Events.Where(x => x.Start >= startDate && x.End <= endDate);
        }
        public async Task<IEnumerable<CalendarEvent>> GetAllEventsFromCalendarAsync(string calendarId)
        {
            var result = await dbCollection
                .Find(x => x.Id == new ObjectId(calendarId))
                .FirstOrDefaultAsync();
            return result?.Events ?? new List<CalendarEvent>(); // null if calendar not exists
        }
        public async Task<CalendarEvent?> AddEventAsync(string calendarId, CalendarEvent calendarEvent)
        {
            calendarEvent.LastUpdateDate = DateTimeOffset.UtcNow;
            calendarEvent.CreatedDate = DateTimeOffset.UtcNow;
            calendarEvent.Start = calendarEvent.Start.ToUniversalTime();
            calendarEvent.End = calendarEvent.End.ToUniversalTime();
            calendarEvent.StartSeries = calendarEvent.StartSeries?.ToUniversalTime();
            calendarEvent.EndSeries = calendarEvent.StartSeries?.ToUniversalTime();
            calendarEvent.Id = ObjectId.GenerateNewId();
            var update = new UpdateDefinitionBuilder<UserCalendar>()
                .AddToSet(x => x.Events, calendarEvent);
            var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(calendarId), update);
            return result.IsAcknowledged ? calendarEvent : null;
        }
        public async Task<CalendarEvent?> UpdateEventAsync(string calendarId, CalendarEvent lectureEvent)
        {
            var calendar = await dbCollection.Find(x => x.Id == new ObjectId(calendarId)).FirstOrDefaultAsync();
            ArgumentNullException.ThrowIfNull(calendarId);

            var itemToUpdate = calendar.Events.FirstOrDefault(x => x.Id == lectureEvent.Id);
            ArgumentNullException.ThrowIfNull(itemToUpdate);
            itemToUpdate.LastUpdateDate = DateTimeOffset.UtcNow;
            itemToUpdate.Location = itemToUpdate.Location;
            itemToUpdate.Description = itemToUpdate.Description;
            itemToUpdate.Start = itemToUpdate.Start;
            itemToUpdate.End = itemToUpdate.End;
            itemToUpdate.StartSeries = itemToUpdate.StartSeries;
            itemToUpdate.EndSeries = itemToUpdate.EndSeries;

            var update = new UpdateDefinitionBuilder<UserCalendar>()
                .Set(x => x.Events.First(x => x.Id == lectureEvent.Id), itemToUpdate);
            var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(calendarId), update);
            // TODO test this method
            var updatedItem = (await dbCollection.Find(x => x.Id == new ObjectId(calendarId)).FirstOrDefaultAsync())?.Events.FirstOrDefault(x => x.Id == lectureEvent.Id);
            return result.ModifiedCount > 0 ? updatedItem : null;
        }

        public async Task<bool> DeleteEventByIdAsync(string calendarId, string eventId)
        {
            var calendar = await dbCollection.Find(x => x.Id == new ObjectId(calendarId)).FirstOrDefaultAsync();
            var item = calendar?.Events.FirstOrDefault(x => x.Id == new ObjectId(eventId));
            if (item is null)
                return false;
            var update = new UpdateDefinitionBuilder<UserCalendar>().Pull(x => x.Events, item);
            var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(calendarId), update);
            return result.ModifiedCount > 0;
        }
    }
}