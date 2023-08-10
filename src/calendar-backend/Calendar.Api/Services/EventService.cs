﻿using Calendar.Api.Models;
using Calendar.Api.Services.Interfaces;
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
            var result = await dbCollection.Find(x => x.Id.ToString() == calendarId).FirstOrDefaultAsync() ??
                         throw new KeyNotFoundException("Calendar was not found.");
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
            return result.Events.Where(x => x.Start >= startDate && (x.Start + x.Duration) <= endDate);
        }
        public async Task<IEnumerable<CalendarEvent>?> GetAllEventsFromCalendarAsync(string calendarId)
        {
            var result = await dbCollection
                .Find(x => x.Id == new ObjectId(calendarId))
                .FirstOrDefaultAsync() ?? throw new KeyNotFoundException("Calendar was not found.");
            return result.Events;
        }

        public async Task<IEnumerable<CalendarEvent>?> GetSeriesEventsAsync(string calendarId, ObjectId serieId)
        {
            var calendar = await dbCollection
                .Find(x => x.Id == new ObjectId(calendarId))
                .FirstOrDefaultAsync();

            if (calendar == null)
                throw new KeyNotFoundException("Calendar was not found.");

            var serieEvents = calendar.Events.Where(x => x.SerieId == serieId);

            if (serieEvents.IsNullOrEmpty())
                return null;

            return serieEvents;
        }

        public async Task<IEnumerable<CalendarEvent>?> AddEventAsync(string calendarId, CalendarEvent calendarEvent)
        {
            EventValidator.ValidateAddEvent(calendarEvent);

            var eventsToAdd = new List<CalendarEvent>();
            // TODO remove redundancy
            // Creating Events
            if (calendarEvent.Rotation != EventRotation.None && calendarEvent.EndSeries.HasValue)
            {
                eventsToAdd = calendarEvent.Rotation switch
                {
                    EventRotation.Daily => CreateEventsForDailySerie(calendarEvent),
                    EventRotation.Weekly => CreateEventsForWeeklySerie(calendarEvent),
                    EventRotation.Monthly => CreateEventsForMonthlySerie(calendarEvent),
                    _ => throw new Exception("There was no rotation enum to hit.")
                };
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
            if (itemToUpdate == null) return null;

            itemToUpdate.LastUpdateDate = DateTimeOffset.UtcNow;
            itemToUpdate.Location = calendarEvent.Location;
            itemToUpdate.Description = calendarEvent.Description;
            itemToUpdate.Start = calendarEvent.Start;
            itemToUpdate.Duration = calendarEvent.Duration;
            itemToUpdate.InstructorsIds = calendarEvent.InstructorsIds;

            // TODO what if whe a lectur only has one session?
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

        public async Task<IEnumerable<CalendarEvent>?> UpdateEventSerieAsync(string calendarId, CalendarEvent calendarEvent)
        {
            if (!calendarEvent.SerieId.HasValue) ArgumentNullException.ThrowIfNull(calendarEvent.SerieId);

            var calendar = await dbCollection.AsQueryable().FirstAsync(x => x.Id == new ObjectId(calendarId));
            ArgumentNullException.ThrowIfNull(calendarId);

            var oldSerieEvents = calendar.Events.Where(x => x.SerieId == calendarEvent.SerieId.Value);
            if (oldSerieEvents.IsNullOrEmpty()) return null;

            var newSerieEvents = new List<CalendarEvent>();
            // TODO remove redundancy
            if (calendarEvent.Rotation != EventRotation.None && calendarEvent.EndSeries.HasValue)
            {
                newSerieEvents = calendarEvent.Rotation switch
                {
                    EventRotation.Daily => CreateEventsForDailySerie(calendarEvent),
                    EventRotation.Weekly => CreateEventsForWeeklySerie(calendarEvent),
                    EventRotation.Monthly => CreateEventsForMonthlySerie(calendarEvent),
                    _ => throw new Exception("There was no rotation enum to hit.")
                };

            }

            var filterBuilder = Builders<UserCalendar>.Filter;
            var filter = filterBuilder.Eq(x => x.Id, new ObjectId(calendarId));

            var updateBuilder = Builders<UserCalendar>.Update;
            var update1 = updateBuilder.PullAll(x => x.Events, oldSerieEvents);
            var update2 = updateBuilder.PushEach(x => x.Events, newSerieEvents);
            var result1 = await dbCollection.UpdateOneAsync(filter, update1);
            var result2 = await dbCollection.UpdateOneAsync(filter, update2);

            return result1.ModifiedCount > 0 && result2.ModifiedCount > 0 ? newSerieEvents : null;
        }

        public async Task<bool> DeleteEventSerieByIdAsync(string calendarId, ObjectId serieId)
        {
            var eventsToDelete = await GetSeriesEventsAsync(calendarId, serieId);
            if (eventsToDelete == null) return false;
            var update = new UpdateDefinitionBuilder<UserCalendar>().PullAll(x => x.Events, eventsToDelete);
            var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(calendarId), update);
            return result.ModifiedCount > 0;
        }

        public async Task<bool> DeleteEventByIdAsync(string calendarId, string eventId)
        {
            var calendar = await dbCollection.Find(x => x.Id.ToString() == calendarId).FirstOrDefaultAsync();

            if (calendar == null) throw new KeyNotFoundException("Calendar was not found.");

            var calendarEvent = calendar.Events.FirstOrDefault(x => x.Id.ToString() == eventId);

            if (calendarEvent == null) return false;

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
        // TODO remove redundancy
        private List<CalendarEvent> CreateEventsForDailySerie(CalendarEvent firstEventInSeries)
        {
            if (!firstEventInSeries.EndSeries.HasValue || !firstEventInSeries.StartSeries.HasValue)
            {
                throw new Exception();
            }

            var serieId = firstEventInSeries.SerieId ?? ObjectId.GenerateNewId();
            var serieStart = firstEventInSeries.StartSeries.Value;
            var eventEnd = firstEventInSeries.Start + firstEventInSeries.Duration;

            var serieEnd = firstEventInSeries.EndSeries.Value;
            serieEnd = new DateTimeOffset(serieEnd.Year, serieEnd.Month, serieEnd.Day, eventEnd.Hour, eventEnd.Minute, eventEnd.Second, TimeSpan.Zero);

            var result = new List<CalendarEvent>();

            for (int i = 0; serieStart <= serieEnd; i++)
            {
                var newCalendar = new CalendarEvent(firstEventInSeries, serieId);
                newCalendar.Start = newCalendar.Start.AddDays(i);
                newCalendar.EndSeries = serieEnd;
                result.Add(newCalendar);
                serieStart = serieStart.AddDays(1);
            }
            return result;
        }
        // TODO remove redundancy
        private List<CalendarEvent> CreateEventsForWeeklySerie(CalendarEvent firstEventInSeries)
        {
            if (!firstEventInSeries.EndSeries.HasValue || !firstEventInSeries.StartSeries.HasValue)
            {
                throw new Exception();
            }

            var serieId = firstEventInSeries.SerieId ?? ObjectId.GenerateNewId();
            var serieStart = firstEventInSeries.StartSeries.Value;
            var eventEnd = firstEventInSeries.Start + firstEventInSeries.Duration;

            var serieEnd = firstEventInSeries.EndSeries.Value;
            serieEnd = new DateTimeOffset(serieEnd.Year, serieEnd.Month, serieEnd.Day, eventEnd.Hour, eventEnd.Minute, eventEnd.Second, TimeSpan.Zero);

            var result = new List<CalendarEvent>();

            for (int i = 0; serieStart <= serieEnd; i += 7)
            {
                var newCalendar = new CalendarEvent(firstEventInSeries, serieId);
                newCalendar.Start = newCalendar.Start.AddDays(i);
                newCalendar.EndSeries = serieEnd;
                result.Add(newCalendar);
                serieStart = serieStart.AddDays(7);
            }
            return result;
        }
        // TODO remove redundancy
        private List<CalendarEvent> CreateEventsForMonthlySerie(CalendarEvent firstEventInSeries)
        {
            if (!firstEventInSeries.EndSeries.HasValue || !firstEventInSeries.StartSeries.HasValue)
            {
                throw new Exception();
            }

            var serieId = firstEventInSeries.SerieId ?? ObjectId.GenerateNewId();
            var serieStart = firstEventInSeries.StartSeries.Value;
            var eventEnd = firstEventInSeries.Start + firstEventInSeries.Duration;

            var serieEnd = firstEventInSeries.EndSeries.Value;
            serieEnd = new DateTimeOffset(serieEnd.Year, serieEnd.Month, serieEnd.Day, eventEnd.Hour, eventEnd.Minute, eventEnd.Second, TimeSpan.Zero);

            var result = new List<CalendarEvent>();

            for (int i = 0; serieStart <= serieEnd; i++)
            {
                var newCalendar = new CalendarEvent(firstEventInSeries, serieId);
                newCalendar.Start = newCalendar.Start.AddMonths(i);
                newCalendar.EndSeries = serieEnd;
                result.Add(newCalendar);
                serieStart = serieStart.AddMonths(1);
            }
            return result;
        }
    }
}