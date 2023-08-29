using Calendar.Api.Exceptions;
using Calendar.Api.Models;
using Calendar.Api.Services.Interfaces;
using Calendar.Api.Utilities.ExtensionMethods;
using Calendar.Api.Validation;
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

        public EventService(ILogger<ICalendarService> logger, IMongoDatabase db)
        {
            this.logger = logger;
            dbCollection = db.GetCollection<UserCalendar>(nameof(UserCalendar));
            ArgumentNullException.ThrowIfNull(dbCollection);
        }
        public async Task<CalendarEvent?> GetEventAsync(string calendarId, string eventId)
        {
            var calendar = await dbCollection.Find(x => x.Id == new ObjectId(calendarId)).FirstOrDefaultAsync();
            if(calendar == null) throw new KeyNotFoundException("Calendar was not found.");
            var resultEvent = calendar.Events.FirstOrDefault(x => x.Id == new ObjectId(eventId));
            return resultEvent == null ? throw new KeyNotFoundException("Event was not found.") : resultEvent;
        }
        public async Task<IEnumerable<CalendarEvent>?> GetEventsAsync(string calendarId, ViewType viewType, DateTimeOffset date)
        {
            var result = await dbCollection
                .Find(x => x.Id == new ObjectId(calendarId))
                .FirstOrDefaultAsync();
            if (result == null)
                return null; // null if calendar not exists
            DateTimeOffset start;
            DateTimeOffset end;
            switch (viewType)
            {
                case ViewType.day:
                    start = date;
                    end = date.AddDays(1);
                    break;
                case ViewType.week:
                    start = date.AddDays(-(int)date.DayOfWeek);
                    end = start.AddDays(7).AddTicks(-1);
                    break;
                case ViewType.month:
                    start = date.AddDays((-date.Day) + 1);
                    // why ticks -1 see: https://stackoverflow.com/questions/24245523/getting-the-first-and-last-day-of-a-month-using-a-given-datetime-object
                    end = start.AddMonths(1).AddTicks(-1);
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(viewType), viewType, null);
            }

            return result.Events.Where(x => x.Start >= start && (x.Start + x.Duration) <= end);
        }
        public async Task<IEnumerable<CalendarEvent>> GetAllEventsFromCalendarAsync(string calendarId)
        {
            var result = await dbCollection.Find(x => x.Id == new ObjectId(calendarId)).FirstOrDefaultAsync();
            if (result == null) throw new KeyNotFoundException("Calendar was not found.");
            return result.Events;
        }

        public async Task<IEnumerable<CalendarEvent>?> AddEventAsync(string calendarId, CalendarEvent calendarEvent)
        {
            calendarEvent.ValidateSeriesTimes();
            calendarEvent.CalendarId = calendarId;

            var eventsToAdd = new List<CalendarEvent>();

            // Creating one or more Events
            if (calendarEvent.Repeat == EventRepeat.None)
            {
                eventsToAdd.Add(CreateEvent(calendarEvent));
            }
            else
            {
                eventsToAdd.AddRange(CreateEvents(calendarEvent, false));
            }

            var update = new UpdateDefinitionBuilder<UserCalendar>().AddToSetEach(x => x.Events, eventsToAdd);
            var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(calendarId), update);

            return result.IsAcknowledged ? eventsToAdd : null;
        }



        public async Task<CalendarEvent> UpdateEventAsync(string calendarId, CalendarEvent calendarEvent)
        {
            ArgumentNullException.ThrowIfNull(calendarId);
            var calendar = await dbCollection.AsQueryable().FirstAsync(x => x.Id == new ObjectId(calendarId));
            if (calendar == null) throw new KeyNotFoundException("Calendar was not found.");

            var eventToUpdate = calendar.Events.FirstOrDefault(x => x.Id == calendarEvent.Id);
            if (eventToUpdate == null) throw new KeyNotFoundException("Event was not found.");

            // Check for conflict.
            if (eventToUpdate.LastUpdateDate.TrimMilliseconds() != calendarEvent.LastUpdateDate.TrimMilliseconds()) throw new ConflictException<CalendarEvent>(eventToUpdate);

            var sharedUtc = DateTimeOffset.UtcNow;

            var filter = Builders<UserCalendar>.Filter.And(
                Builders<UserCalendar>.Filter.Eq(x => x.Id, new ObjectId(calendarId)),
                Builders<UserCalendar>.Filter.ElemMatch(x => x.Events, e => e.Id == eventToUpdate.Id));
            
            UpdateDefinition<UserCalendar> update = Builders<UserCalendar>.Update
                .Set(x => x.Events.FirstMatchingElement().Location, calendarEvent.Location)
                .Set(x => x.Events.FirstMatchingElement().Description, calendarEvent.Description)
                .Set(x => x.Events.FirstMatchingElement().Start, calendarEvent.Start)
                .Set(x => x.Events.FirstMatchingElement().Duration, calendarEvent.Duration)
                .Set(x => x.Events.FirstMatchingElement().Instructors, calendarEvent.Instructors)
                .Set(x => x.Events.FirstMatchingElement().LastUpdateDate, DateTimeOffset.UtcNow)
                .Set(x => x.Events.FirstMatchingElement().LectureId, calendarEvent.LectureId);

            if (eventToUpdate.SeriesId.HasValue)
            {
                var serieFilter = Builders<UserCalendar>.Filter.Eq(x => x.Id, new ObjectId(calendarId));
                var arrayFilters = new List<ArrayFilterDefinition<UserCalendar>>
                {
                    new BsonDocumentArrayFilterDefinition<UserCalendar>(new BsonDocument("$and", 
                    new BsonArray
                    {
                        new BsonDocument($"element.{nameof(CalendarEvent.SeriesId)}", eventToUpdate.SeriesId),
                        new BsonDocument($"element.{nameof(CalendarEvent.Id)}", new BsonDocument("$ne", eventToUpdate.Id))
                    }))
                };

                var serieUpdate = Builders<UserCalendar>.Update.Set($"{nameof(UserCalendar.Events)}.$[element].{nameof(CalendarEvent.LastUpdateDate)}", sharedUtc);

                var updateOptions = new UpdateOptions { ArrayFilters = arrayFilters };
                
                await dbCollection.UpdateOneAsync(serieFilter, serieUpdate, updateOptions);
            }

            var result = await dbCollection.UpdateOneAsync(filter, update);


            if (result.ModifiedCount > 0)
            {
                var resultCalendar = await dbCollection.AsQueryable().FirstAsync(x => x.Id == new ObjectId(calendarId));
                return resultCalendar.Events.First(x => x.Id == eventToUpdate.Id);
            }
            else
            {
                throw new Exception("Problem with updating event");
            }
        }

        public async Task<IEnumerable<CalendarEvent>> UpdateEventSeriesAsync(string calendarId, CalendarEvent calendarEvent)
        {
            ArgumentNullException.ThrowIfNull(calendarId);
            calendarEvent.ValidateSeriesId();

            var calendar = await dbCollection.AsQueryable().FirstOrDefaultAsync(x => x.Id == new ObjectId(calendarId));
            
            if (calendar == null) throw new KeyNotFoundException("Calendar was not found.");

            var oldSeriesEvents = calendar.Events.Where(x => x.SeriesId == calendarEvent.SeriesId).ToList();

            if (oldSeriesEvents.IsNullOrEmpty()) throw new KeyNotFoundException("Series was not found.");

            // If LastUpdateDate not the same, a conflict is occured.
            if (oldSeriesEvents!.Max(x => x.LastUpdateDate).TrimMilliseconds() != calendarEvent.LastUpdateDate.TrimMilliseconds()) throw new ConflictException<IEnumerable<CalendarEvent>>(oldSeriesEvents);


            FilterDefinition<UserCalendar> filter;
            UpdateDefinition<UserCalendar> update;
            List<CalendarEvent>? eventsToUpdate = null;

            var isModified = false;
            

            // delete all old events if the repeat changed or EndSeriesDate changed
            var firstEvent = oldSeriesEvents.First();
            if (firstEvent.Repeat != calendarEvent.Repeat ||
                firstEvent.StartSeries != calendarEvent.StartSeries ||
                firstEvent.EndSeries != calendarEvent.EndSeries ||
                firstEvent.Duration != calendarEvent.Duration ||
                firstEvent.Start != calendarEvent.Start
                )
            {
                calendarEvent.ValidateSeriesTimes();
                calendarEvent.CreatedDate = oldSeriesEvents.First().CreatedDate;
                calendarEvent.CalendarId = calendarId;
                calendarEvent.SeriesId = oldSeriesEvents.First().SeriesId;

                eventsToUpdate = CreateEvents(calendarEvent, true).ToList();

                filter = Builders<UserCalendar>.Filter.Where(x => x.Id == new ObjectId(calendarId));
                update = Builders<UserCalendar>.Update.PushEach(x => x.Events, eventsToUpdate);
                var updatePull = Builders<UserCalendar>.Update.PullFilter(x => x.Events, e => e.SeriesId == calendarEvent.SeriesId);
                await dbCollection.UpdateOneAsync(filter, updatePull);
                var result = await dbCollection.UpdateOneAsync(filter, update);
                isModified = result.ModifiedCount > 0;
            }
            
            else
            {
                var sharedUtc = DateTimeOffset.UtcNow;
                var serieFilter = Builders<UserCalendar>.Filter.Eq(x => x.Id, new ObjectId(calendarId));
                var arrayFilters = new List<ArrayFilterDefinition<UserCalendar>>
                {
                    new BsonDocumentArrayFilterDefinition<UserCalendar>(new BsonDocument("$and",
                    new BsonArray
                    {
                        new BsonDocument($"element.{nameof(CalendarEvent.SeriesId)}", oldSeriesEvents.First().SeriesId)
                    }))
                };

                var serieUpdate = Builders<UserCalendar>.Update
                    .Set($"{nameof(UserCalendar.Events)}.$[element].{nameof(CalendarEvent.LastUpdateDate)}", sharedUtc)
                    .Set($"{nameof(UserCalendar.Events)}.$[element].{nameof(CalendarEvent.LectureId)}", calendarEvent.LectureId)
                    .Set($"{nameof(UserCalendar.Events)}.$[element].{nameof(CalendarEvent.Location)}", calendarEvent.Location)
                    .Set($"{nameof(UserCalendar.Events)}.$[element].{nameof(CalendarEvent.Description)}", calendarEvent.Description)
                    .Set($"{nameof(UserCalendar.Events)}.$[element].{nameof(CalendarEvent.Instructors)}", calendarEvent.Instructors);

                var updateOptions = new UpdateOptions { ArrayFilters = arrayFilters };

                var result = await dbCollection.UpdateOneAsync(serieFilter, serieUpdate, updateOptions);
                isModified = result.ModifiedCount > 0;
            }

            if (isModified)
            {
                var resultCalendar = await dbCollection.AsQueryable().FirstAsync(x => x.Id == new ObjectId(calendarId));
                return resultCalendar.Events.Where(x => x.SeriesId == calendarEvent.SeriesId);
            }
            else
            {
                throw new Exception("Problem with updating series");
            }


            

        }

        public async Task<bool> DeleteEventSeriesByIdAsync(string calendarId, string seriesId)
        {
            var countCalendars = await dbCollection.CountDocumentsAsync(x => x.Id == new ObjectId(calendarId));
            if (countCalendars == 0) throw new KeyNotFoundException("Calendar was not found.");
            var update = new UpdateDefinitionBuilder<UserCalendar>().PullFilter(x => x.Events, e => e.SeriesId == new ObjectId(seriesId));
            var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(calendarId), update);
            return result.ModifiedCount > 0;
        }

        public async Task<bool> DeleteEventByIdAsync(string calendarId, string eventId)
        {
            var countCalendars = await dbCollection.CountDocumentsAsync(x => x.Id == new ObjectId(calendarId));
            if (countCalendars == 0) throw new KeyNotFoundException("Calendar was not found.");
            var deleteEventUpdate = new UpdateDefinitionBuilder<UserCalendar>().PullFilter(x => x.Events, e => e.Id == new ObjectId(eventId));
            var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(calendarId), deleteEventUpdate);
            return result.ModifiedCount > 0;
        }

        private CalendarEvent CreateEvent(CalendarEvent calendarEvent)
        {
            return new CalendarEvent()
            {
                Id = ObjectId.GenerateNewId(),
                Description = calendarEvent.Description,
                Location = calendarEvent.Location,
                Start = calendarEvent.Start,
                Duration = calendarEvent.Duration,
                LectureId = calendarEvent.LectureId,
                Instructors = calendarEvent.Instructors,
                CalendarId = calendarEvent.CalendarId,
                CreatedDate = DateTimeOffset.UtcNow,
                LastUpdateDate = DateTimeOffset.UtcNow,
                Repeat = EventRepeat.None,
            };
        }


        // Prüfen
        private static IEnumerable<CalendarEvent> CreateEvents(CalendarEvent firstEvent, bool isUpdate)
        {
            if (firstEvent.Repeat == EventRepeat.None)
            {
                yield return firstEvent;
                yield break;
            }

            if (!firstEvent.EndSeries.HasValue) throw new NullReferenceException(nameof(firstEvent.EndSeries));


            var shardUtcNow = DateTimeOffset.UtcNow;
            var endEvent = firstEvent.Start + firstEvent.Duration;
            var seriesId = firstEvent.SeriesId ?? ObjectId.GenerateNewId();
            if(firstEvent.StartSeries == null) throw new NullReferenceException(nameof(firstEvent.StartSeries));
            var seriesStart = firstEvent.StartSeries.Value;
            seriesStart = new DateTimeOffset(seriesStart.Year, seriesStart.Month, seriesStart.Day, firstEvent.Start.Hour, firstEvent.Start.Minute, 0, TimeSpan.Zero);
            // Need this seriesEnd Date which contains the event also on the day of series end.
            var seriesEnd = new DateTimeOffset(firstEvent.EndSeries.Value.Year, firstEvent.EndSeries.Value.Month, firstEvent.EndSeries.Value.Day, endEvent.Hour,
                endEvent.Minute, 0, TimeSpan.Zero);
            while (seriesStart <= seriesEnd)
            {
                var calendarEvent = new CalendarEvent()
                {
                    Id = ObjectId.GenerateNewId(),
                    Description = firstEvent.Description,
                    Location = firstEvent.Location,
                    LectureId = firstEvent.LectureId,
                    Instructors = firstEvent.Instructors,
                    CalendarId = firstEvent.CalendarId,
                    CreatedDate = !isUpdate ? shardUtcNow : firstEvent.CreatedDate,
                    LastUpdateDate = shardUtcNow,
                    Start = seriesStart,
                    Duration = firstEvent.Duration,
                    Repeat = firstEvent.Repeat,
                    SeriesId = seriesId,
                    StartSeries = firstEvent.StartSeries,
                    EndSeries = new DateTimeOffset(seriesEnd.Year, seriesEnd.Month, seriesEnd.Day, 0, 0, 0, TimeSpan.Zero),
                };
                seriesStart = firstEvent.Repeat switch
                {
                    EventRepeat.Daily => seriesStart.AddDays(1),
                    EventRepeat.Weekly => seriesStart.AddDays(7),
                    EventRepeat.Monthly => seriesStart.AddMonths(1),
                    _ => throw new NotSupportedException(nameof(firstEvent.Repeat)),
                };
                yield return calendarEvent
                    .ValidateSeriesId()
                    .ValidateLocation();
            }
        }

    }
}