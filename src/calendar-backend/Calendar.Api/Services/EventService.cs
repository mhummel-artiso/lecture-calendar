﻿using Calendar.Api.Models;
using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using MongoDB.Driver;
using MongoDB.Driver.Linq;

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
        
        public async Task<CalendarEvent?> GetEventAsync(string calendarId, string eventId)
        {
            var result = await dbCollection.Find(x => x.Id == calendarId).FirstOrDefaultAsync();
            return result?.Events?.FirstOrDefault(x => x.Id == eventId);
        }
        
        public async Task<IEnumerable<CalendarEvent>?> GetEventsAsync(string calendarId, ViewType viewType, DateTime date)
        {
            var result = await dbCollection
                .Find(x => x.Id == calendarId)
                .FirstOrDefaultAsync();
            if (result == null)
                return null; // null if calendar not exists
            var startDate = new DateTimeOffset(date.AddDays(-(int)date.DayOfWeek));
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
                .Find(x => x.Id == calendarId)
                .FirstOrDefaultAsync();
            return result?.Events ?? new List<CalendarEvent>(); // null if calendar not exists
        }
   
        public async Task<CalendarEvent?> AddEventAsync(string calendarId, CalendarEvent calendarEvent)
        {
            var update = new UpdateDefinitionBuilder<UserCalendar>().AddToSet(x => x.Events, calendarEvent);
            var result = await dbCollection.UpdateOneAsync(x => x.Id == calendarId, update);
            return result.IsAcknowledged ? calendarEvent : null;
        }
        
        public async Task<CalendarEvent?> UpdateEventAsync(string calendarId, CalendarEvent lectureEvent)
        {
            var update = new UpdateDefinitionBuilder<UserCalendar>()
                .Set(x => x.Events.First(x => x.Id == lectureEvent.Id), lectureEvent);
            var result = await dbCollection.UpdateOneAsync(x => x.Id == calendarId, update);
            // TODO test this method
            return result.IsAcknowledged ? lectureEvent : null;
        }
        public async Task<bool> DeleteEventByIdAsync(string calendarId, string eventId)
        {
            var calendar = await dbCollection.Find(x => x.Id == calendarId).FirstOrDefaultAsync();
            var item = calendar?.Events.FirstOrDefault(x => x.Id == eventId);
            if (item is null)
                return false;
            var update = new UpdateDefinitionBuilder<UserCalendar>().Pull(x => x.Events, item);
            var result = await dbCollection.UpdateOneAsync(x => x.Id == calendarId, update);
            return result.IsAcknowledged;
        }
    }
}