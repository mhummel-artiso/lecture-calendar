using Calendar.Api.Models;

namespace Calendar.Api.Services;

public class CalendarService : ICalendarService
{
    private readonly ILogger<ICalendarService> logger;
    public CalendarService(ILogger<ICalendarService> logger)
    {
        this.logger = logger;
    }
    public IEnumerable<CalendarItem> GetCalendars() => throw new NotImplementedException();
    public CalendarItem GetCalendar(Guid studentClass) => throw new NotImplementedException();
}