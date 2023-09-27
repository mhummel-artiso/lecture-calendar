using Calendar.Api.Models;
using Calendar.Mongo.Db.Models;
using Calendar.Api.Exceptions;

namespace Calendar.Api.Services.Interfaces
{
    public interface IEventService
    {
        /// <summary>
        /// Get event
        /// </summary>
        /// <param name="calendarId">calendar id</param>
        /// <param name="eventId">event id</param>
        /// <returns><see cref="CalendarEvent"/></returns>
        /// <exception cref="KeyNotFoundException">There is no calendar with the calendar id.</exception>
        /// <exception cref="KeyNotFoundException">There is no event with the event id.</exception>
        Task<CalendarEvent> GetEventAsync(string calendarId, string eventId);

        /// <summary>
        /// Get events from calendar from specific day, week or month
        /// </summary>
        /// <param name="calendarId">calendar id</param>
        /// <param name="viewType">should it a day, week or month</param>
        /// <param name="date">date</param>
        /// <returns>A nullable collection of <see cref="CalendarEvent"/></returns>
        /// <exception cref="ArgumentOutOfRangeException">viewType not found</exception>
        Task<IEnumerable<CalendarEvent>?> GetEventsAsync(string calendarId, ViewType viewType, DateTimeOffset date);

        /// <summary>
        /// Get all events from calendar
        /// </summary>
        /// <param name="calendarId">calendar id</param>
        /// <returns>A collection of <see cref="CalendarEvent"/></returns>
        /// <exception cref="KeyNotFoundException">There is no calendar with the calendar id.</exception>
        Task<IEnumerable<CalendarEvent>> GetAllEventsFromCalendarAsync(string calendarId);

        /// <summary>
        /// Add a new event or series
        /// </summary>
        /// <param name="calendarId">calendar id</param>
        /// <param name="calendarEvent">event to create event/series</param>
        /// <returns>A nullable collection of <see cref="CalendarEvent"/></returns>
        /// <exception cref="ArgumentNullException">invalid time inputs</exception>
        /// <exception cref="ArgumentNullException">calendar id is null</exception>
        Task<IEnumerable<CalendarEvent>?> AddEventAsync(string calendarId, CalendarEvent calendarEvent);

        /// <summary>
        /// Update a specific event
        /// </summary>
        /// <param name="calendarId">calendar id</param>
        /// <param name="calendarEvent">event to update</param>
        /// <returns><see cref="CalendarEvent"/></returns>
        /// <exception cref="KeyNotFoundException">There is no calendar with the calendar id.</exception>
        /// <exception cref="KeyNotFoundException">There is no event with the event id.</exception>
        /// <exception cref="ConflictException{T}">lecture.LastUpdateDate is not the same as in the database.</exception>
        /// <exception cref="ArgumentNullException">calendar id is null</exception>
        /// <exception cref="Exception">problem while updating</exception>
        Task<CalendarEvent> UpdateEventAsync(string calendarId, CalendarEvent calendarEvent);

        /// <summary>
        /// Update a event series
        /// </summary>
        /// <param name="calendarId">calendar id</param>
        /// <param name="calendarEvent">event to update</param>
        /// <returns>A collection of <see cref="CalendarEvent"/></returns>
        /// <exception cref="KeyNotFoundException">There is no calendar with the calendar id.</exception>
        /// <exception cref="KeyNotFoundException">There is no serie with the serie id.</exception>
        /// <exception cref="ConflictException{T}">lecture.LastUpdateDate is not the same as in the database.</exception>
        /// <exception cref="ArgumentNullException">calendar id is null</exception>
        /// <exception cref="Exception">problem while updating</exception>
        Task<IEnumerable<CalendarEvent>> UpdateEventSeriesAsync(string calendarId, CalendarEvent calendarEvent);

        /// <summary>
        /// Delete a event
        /// </summary>
        /// <param name="calendarId">calendar id</param>
        /// <param name="eventId">event id</param>
        /// <returns><see cref="bool"/></returns>
        /// <exception cref="KeyNotFoundException">There is no calendar with the calendar id.</exception>
        Task<bool> DeleteEventByIdAsync(string calendarId, string eventId);

        /// <summary>
        /// Delete series (all events)
        /// </summary>
        /// <param name="calendarId">calendar id</param>
        /// <param name="seriesId">series id</param>
        /// <returns><see cref="bool"/></returns>
        /// <exception cref="KeyNotFoundException">There is no calendar with the calendar id.</exception>
        Task<bool> DeleteEventSeriesByIdAsync(string calendarId, string seriesId);
    }
}