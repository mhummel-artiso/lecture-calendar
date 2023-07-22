namespace Calendar.Api.DTOs.Create
{
    public class CreateCalendarEventDTO
    {
        public string? Location { get; set; }
        public string? LectureId { get; set; }
        public DateTimeOffset Start { get; set; }
        public DateTimeOffset End { get; set; }
        public DateTimeOffset StartSeries { get; set; }
        public DateTimeOffset EndSeries { get; set; }
    }
}