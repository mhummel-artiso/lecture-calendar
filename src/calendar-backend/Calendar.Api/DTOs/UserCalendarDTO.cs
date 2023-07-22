namespace Calendar.Api.DTOs
{
    public class UserCalendarDTO
    {
        public string? Id { get; set; }
        public string? Name { get; set; }
        public DateTimeOffset StartDate { get; set; }
        public List<CalendarEventDTO>? Events { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
