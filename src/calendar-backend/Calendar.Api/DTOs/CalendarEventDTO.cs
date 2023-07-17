using Calendar.Mongo.Db.Models;

namespace Calendar.Api.DTOs
{
    public class CalendarEventDTO
    {
        public string? Id { get; set; }
        public string? Location { get; set; }
        public DateTimeOffset Start { get; set; }
        public DateTimeOffset End { get; set; }
        public DateTimeOffset StartSeries { get; set; }
        public DateTimeOffset EndSeries { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
        public DateTimeOffset LastUpdateDate { get; set; }
        public Lecture? Lecture { get; set; }
    }
}