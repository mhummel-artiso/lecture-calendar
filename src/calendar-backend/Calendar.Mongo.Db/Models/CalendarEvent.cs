using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

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
        public DateTimeOffset End { get; set; }

        public ObjectId? SerieId { get; set; }

        public EventRotation? Rotation { get; set; }

        [BsonRequired]
        public DateTimeOffset CreatedDate { get; set; }

        [BsonRequired]
        public DateTimeOffset LastUpdateDate { get; set; }

        public List<string>? InstructorsIds { get; set; }

        [BsonRequired]
        public string? LectureId { get; set; }


        public CalendarEvent(){}

        public CalendarEvent(CalendarEvent calendarEvent, ObjectId serieId)
        {
            Id = ObjectId.GenerateNewId();
            Location = calendarEvent.Location;
            Description = calendarEvent.Description;
            Start = calendarEvent.Start.ToUniversalTime();
            End = calendarEvent.End.ToUniversalTime();
            LastUpdateDate = calendarEvent.LastUpdateDate.ToUniversalTime();
            CreatedDate = calendarEvent.CreatedDate.ToUniversalTime();
            LectureId = calendarEvent.LectureId;
            Rotation = calendarEvent.Rotation;
            SerieId = serieId;
        }

        public CalendarEvent ToUTC()
        {
            Start = Start.ToUniversalTime();
            End = End.ToUniversalTime();
            LastUpdateDate = End.ToUniversalTime();
            CreatedDate = CreatedDate.ToUniversalTime();
            return this;
        }

        public CalendarEvent CreateMetaData()
        {
            Id = ObjectId.GenerateNewId();
            CreatedDate = DateTimeOffset.UtcNow;
            LastUpdateDate = DateTimeOffset.UtcNow;
            return this;
        }
    }
}