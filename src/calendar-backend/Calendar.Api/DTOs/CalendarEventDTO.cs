using Calendar.Api.Models;
using Calendar.Mongo.Db.Models;
using System.Text.Json.Serialization;

namespace Calendar.Api.DTOs
{
    public class CalendarEventDTO
    {
        // Mapping
        public string? Id { get; set; }
        public string? Location { get; set; }
        public string? Description { get; set; }
        public DateTimeOffset Start { get; set; }
        public DateTimeOffset End { get; set; }
        public EventRepeat? Repeat { get; set; }
        public string? SeriesId { get; set; }
        public DateTimeOffset LastUpdateDate { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
        
        // Fill in controller
        public LectureDTO? Lecture { get; set; }
        public DateTimeOffset? StartSeries { get; set; }
        public DateTimeOffset? EndSeries { get; set; }
        public List<Instructor>? Instructors { get; set; }

        [JsonIgnore]
        public List<string>? InstructorsIds { get; set; }

        [JsonIgnore]
        public string? LectureId { get; set; }
        public string? CalendarId { get; set; }
    }
}