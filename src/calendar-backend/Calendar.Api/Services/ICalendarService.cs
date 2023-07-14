using Calendar.Api.Models;

namespace Calendar.Api.Services;

// order of methods
// Get
// Add
// Update
// Delete

public interface ICalendarService
{
    IEnumerable<CalendarItem> GetCalendars();
    CalendarItem GetCalendar(Guid studentClass);
}