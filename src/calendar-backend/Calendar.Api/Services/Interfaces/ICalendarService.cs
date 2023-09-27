using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces;

public interface ICalendarService
{
    /// <summary>
    /// Get calendars filtered by names
    /// </summary>
    /// <param name="names">names of calendars which are searched for</param>
    /// <param name="includeEvents">if calendars should contains events</param>
    /// <returns>A collection of<see cref="UserCalendar"/></returns>
    Task<IEnumerable<UserCalendar>> GetCalendarsByNamesAsync(IEnumerable<string> names, bool includeEvents = false);

    /// <summary>
    /// Get a calendar
    /// </summary>
    /// <param name="calendarId">calendar ID</param>
    /// <param name="includeEvents">return calendar with or without events</param>
    /// <returns>A nullable <see cref="UserCalendar"/></returns>
    Task<UserCalendar?> GetCalendarByIdAsync(string calendarId,bool includeEvents = false);

    /// <summary>
    /// Add a new calendar
    /// </summary>
    /// <param name="calendar">calendar to add</param>
    /// <returns><see cref="UserCalendar"/></returns>
    /// <exception cref="KeyNotFoundException">There is already an calendar with the same name.</exception>
    Task<UserCalendar> AddCalendarAsync(UserCalendar calendar);

    /// <summary>
    /// Update a specific calendar
    /// </summary>
    /// <param name="calendarId">calendar id</param>
    /// <param name="updateCalendar">calendar with new states</param>
    /// <returns>A nullable <see cref="UserCalendar"/></returns>
    Task<UserCalendar?> UpdateCalendarAsync(string calendarId, UserCalendar updateCalendar);

    /// <summary>
    /// Delete a calendar
    /// </summary>
    /// <param name="calendarId">calendar id</param>
    /// <returns><see cref="bool"/></returns>
    Task<bool> DeleteCalendarByIdAsync(string calendarId);

    /// <summary>
    /// Get all calendar without there events
    /// </summary>
    /// <returns>A collection of<see cref="UserCalendar"/></returns>
    Task<IEnumerable<UserCalendar>> GetCalendars();
}