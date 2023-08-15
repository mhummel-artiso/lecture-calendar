using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson.Serialization.Options;

namespace Calendar.Mongo.Db.Models
{
    public class CalendarEvent
    {
        [BsonId]
        [BsonRequired]
        public ObjectId Id { get; set; }

        [BsonRequired]
        public string? Location { get; set; }

        public string? Description { get; set; }

        [BsonRequired]
        public DateTimeOffset Start { get; set; }

        [BsonRequired]
        public TimeSpan Duration { get; set; }

        public ObjectId? SerieId { get; set; }

        public EventRotation? Rotation { get; set; }

        public DateTimeOffset? StartSeries { get; set; }

        public DateTimeOffset? EndSeries { get; set; }

        [BsonRequired]
        public DateTimeOffset CreatedDate { get; set; } = DateTimeOffset.Now.ToUniversalTime();

        [BsonRequired]
        public DateTimeOffset LastUpdateDate { get; set; } = DateTimeOffset.Now.ToUniversalTime();

        public List<string>? InstructorsIds { get; set; }

        [BsonRequired]
        public string? LectureId { get; set; }

        public CalendarEvent() { }

        public CalendarEvent(CalendarEvent calendarEvent, ObjectId serieId)
        {
            Id = ObjectId.GenerateNewId();
            Location = calendarEvent.Location;
            Description = calendarEvent.Description;
            Start = calendarEvent.Start.ToUniversalTime();
            Duration = calendarEvent.Duration;
            LastUpdateDate = calendarEvent.LastUpdateDate.ToUniversalTime();
            CreatedDate = calendarEvent.CreatedDate.ToUniversalTime();
            LectureId = calendarEvent.LectureId;
            Rotation = calendarEvent.Rotation;
            SerieId = serieId;
            StartSeries = calendarEvent.StartSeries;
            EndSeries = calendarEvent.EndSeries;
            InstructorsIds = calendarEvent.InstructorsIds;

        }
    }
}