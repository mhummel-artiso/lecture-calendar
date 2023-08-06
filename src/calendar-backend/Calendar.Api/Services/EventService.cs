using Calendar.Api.Models;
using Calendar.Api.Services.Interfaces;
using Calendar.Api.Services.Validation;
using Calendar.Mongo.Db.Models;
using Microsoft.IdentityModel.Tokens;
using MongoDB.Bson;
using MongoDB.Driver;
using MongoDB.Driver.Linq;

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
        public async Task<CalendarEvent> GetEventAsync(string calendarId, string eventId)
        {
            var result = await dbCollection.Find(x => x.Id == new ObjectId(calendarId)).FirstOrDefaultAsync() ?? throw new KeyNotFoundException("Calendar was not found.");
            return result.Events.FirstOrDefault(x => x.Id == new ObjectId(eventId)) ?? throw new KeyNotFoundException("Event was not found.");
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
                .FirstOrDefaultAsync() ?? throw new KeyNotFoundException("Calendar was not found.");
            return result.Events;
        }

        public async Task<IEnumerable<CalendarEvent>> GetSeriesEventsAsync(string calendarId, ObjectId serieId)
        {
            var calendar = await dbCollection
                .Find(x => x.Id == new ObjectId(calendarId))
                .FirstOrDefaultAsync();

            if (calendar == null) throw new KeyNotFoundException("Calendar was not found.");

            if (calendar.Events.IsNullOrEmpty()) throw new KeyNotFoundException("Event was not found.");

            var serieEvents = calendar.Events.Where(x => x.SerieId == serieId);

            if(serieEvents.IsNullOrEmpty()) throw new KeyNotFoundException("Event series was not found.");

            return serieEvents;
        }

        public async Task<IEnumerable<CalendarEvent>?> AddEventAsync(string calendarId, CalendarEvent calendarEvent, DateTimeOffset? serieEnd)
        {
            EventValidationService.ValidateAddEvent(calendarEvent, serieEnd);
            var eventsToAdd = new List<CalendarEvent>();
            calendarEvent.CreateMetaData().ToUTC();

            // Creating Events
            if(serieEnd.HasValue && calendarEvent.Rotation.HasValue)
            {
                if (calendarEvent.Rotation == EventRotation.Daily)
                {
                    eventsToAdd = CreateEventsForDailySerie(serieEnd.Value, calendarEvent);
                }
                else if (calendarEvent.Rotation == EventRotation.Weekly)
                {
                    eventsToAdd = CreateEventsForWeeklySerie(serieEnd.Value, calendarEvent);
                }
                else if (calendarEvent.Rotation == EventRotation.Monthly)
                {
                    eventsToAdd = CreateEventsForMonthlySerie(serieEnd.Value, calendarEvent);
                }
                else
                {
                    throw new Exception("There was no rotation enum to hit.");
                }

            }
            else
            {
                eventsToAdd.Add(calendarEvent);
            }

            var update = new UpdateDefinitionBuilder<UserCalendar>().AddToSetEach(x => x.Events, eventsToAdd);
            var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(calendarId), update);
            
            return result.IsAcknowledged ? eventsToAdd : null;
        }
        public async Task<CalendarEvent?> UpdateEventAsync(string calendarId, CalendarEvent calendarEvent)
        {
            var calendar = await dbCollection.AsQueryable().FirstAsync(x => x.Id == new ObjectId(calendarId));
            ArgumentNullException.ThrowIfNull(calendarId);

            var itemToUpdate = calendar.Events.FirstOrDefault(x => x.Id == calendarEvent.Id);
            ArgumentNullException.ThrowIfNull(itemToUpdate);

            itemToUpdate.LastUpdateDate = DateTimeOffset.UtcNow;
            itemToUpdate.Location = calendarEvent.Location;
            itemToUpdate.Description = calendarEvent.Description;
            itemToUpdate.Start = calendarEvent.Start.ToUniversalTime();
            itemToUpdate.End = calendarEvent.End.ToUniversalTime();
            itemToUpdate.InstructorsIds = calendarEvent.InstructorsIds;
            
            // Can update lecture only, if its no serie.
            if (!itemToUpdate.SerieId.HasValue)
            {
                itemToUpdate.LectureId = calendarEvent.LectureId;
            }
            var filterBuilder = Builders<UserCalendar>.Filter;
            var filter = filterBuilder.Eq(x => x.Id, new ObjectId(calendarId)) &
                filterBuilder.ElemMatch(x => x.Events, el => el.Id == itemToUpdate.Id);

            var updateBuilder = Builders<UserCalendar>.Update;
            var update = updateBuilder.Set(x => x.Events.FirstMatchingElement(), itemToUpdate);
            var result = await dbCollection.UpdateOneAsync(filter, update);
            
            return result.ModifiedCount > 0 ? itemToUpdate : null;
        }

        public async Task<bool> DeleteEventSerieByIdAsync(string calendarId, string serieId)
        {
            var eventsToDelete = await GetSeriesEventsAsync(calendarId, new ObjectId(serieId));
            if (eventsToDelete == null) return false;
            var update = new UpdateDefinitionBuilder<UserCalendar>().PullAll(x => x.Events, eventsToDelete);
            var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(calendarId), update);
            return result.ModifiedCount > 0;
        }

        public async Task<bool> DeleteEventByIdAsync(string calendarId, string eventId)
        {
            var calendar = await dbCollection.Find(x => x.Id == new ObjectId(calendarId)).FirstOrDefaultAsync();

            if (calendar == null) throw new KeyNotFoundException("Calendar was not found.");

            var calendarEvent = calendar.Events.FirstOrDefault(x => x.Id == new ObjectId(eventId));
            
            if(calendarEvent == null) return false;
            
            var isSerie = calendarEvent.SerieId != null;
            
            if (isSerie)
            {
                var updatePullDef = new UpdateDefinitionBuilder<UserCalendar>().Pull(x => x.Events, calendarEvent);
                var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(calendarId), updatePullDef);
                return result.ModifiedCount > 0;
            }
            else
            {
                var updateDef = new UpdateDefinitionBuilder<UserCalendar>().Pull(x => x.Events, calendarEvent);
                var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(calendarId), updateDef);
                return result.ModifiedCount > 0;
            }
        }

        private List<CalendarEvent> CreateEventsForDailySerie(DateTimeOffset endDate, CalendarEvent firstEventInSeries) 
        {
            ObjectId serieId = ObjectId.GenerateNewId();
            var startDate = firstEventInSeries.Start;
            endDate = endDate.ToUniversalTime();
            endDate = new DateTimeOffset(endDate.Year, endDate.Month, endDate.Day, firstEventInSeries.End.Hour, firstEventInSeries.End.Minute, firstEventInSeries.End.Second, TimeSpan.Zero);

            var result = new List<CalendarEvent>();

            for (int i = 0; startDate <= endDate; i++)
            {
                var newCalendar = new CalendarEvent(firstEventInSeries, serieId);
                newCalendar.Start = newCalendar.Start.AddDays(i);
                newCalendar.End = newCalendar.End.AddDays(i);
                result.Add(newCalendar);
                startDate = startDate.AddDays(1);
            }

            return result;
        }

        private List<CalendarEvent> CreateEventsForWeeklySerie(DateTimeOffset endDate, CalendarEvent firstEventInSeries)
        {
            ObjectId serieId = ObjectId.GenerateNewId();
            var startDate = firstEventInSeries.Start;
            endDate = endDate.ToUniversalTime();
            endDate = new DateTimeOffset(endDate.Year, endDate.Month, endDate.Day, firstEventInSeries.End.Hour, firstEventInSeries.End.Minute, firstEventInSeries.End.Second, TimeSpan.Zero);
            
            var result = new List<CalendarEvent>();

            for (int i = 0; startDate <= endDate; i+=7)
            {
                var newCalendar = new CalendarEvent(firstEventInSeries, serieId);
                newCalendar.Start = newCalendar.Start.AddDays(i);
                newCalendar.End = newCalendar.End.AddDays(i);
                result.Add(newCalendar);
                startDate = startDate.AddDays(7);
            }

            return result;
        }

        private List<CalendarEvent> CreateEventsForMonthlySerie(DateTimeOffset endDate, CalendarEvent firstEventInSeries)
        {
            ObjectId serieId = ObjectId.GenerateNewId();
            var startDate = firstEventInSeries.Start;
            endDate = endDate.ToUniversalTime();
            endDate = new DateTimeOffset(endDate.Year, endDate.Month, endDate.Day, firstEventInSeries.End.Hour, firstEventInSeries.End.Minute, firstEventInSeries.End.Second, TimeSpan.Zero);

            var result = new List<CalendarEvent>();

            for (int i = 0; startDate <= endDate; i++)
            {
                var newCalendar = new CalendarEvent(firstEventInSeries, serieId);
                newCalendar.Start = newCalendar.Start.AddMonths(i);
                newCalendar.End = newCalendar.End.AddMonths(i);
                result.Add(newCalendar);
                startDate = startDate.AddMonths(1);
            }

            return result;
        }
    }
}