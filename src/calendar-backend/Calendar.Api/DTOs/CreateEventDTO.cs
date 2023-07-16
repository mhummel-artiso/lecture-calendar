namespace Calendar.Api.DTOs
{
    public class CreateEventDTO
    {
        public string? Location { get; set; }
        public DateTimeOffset Start { get; set; }
        public DateTimeOffset End { get; set; }
        public DateTimeOffset StartSeries { get; set; }
        public DateTimeOffset EndSeries { get; set; }
    }
}
