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
        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset Start { get; set; }

        [BsonRequired]
        public TimeSpan Duration { get; set; }

        public ObjectId? SeriesId { get; set; }

        public EventRepeat Repeat { get; set; }

        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset? StartSeries { get; set; }

        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset? EndSeries { get; set; }

        // do not ToUniversalTime() because only used in api so not need!
        [BsonRequired]
        public DateTimeOffset CreatedDate { get; set; }
        // do not ToUniversalTime() because only used in api so not need!
        [BsonRequired]
        public DateTimeOffset? LastUpdateDate { get; set; }

        public List<string>? InstructorsIds { get; set; }

        [BsonRequired]
        public string? LectureId { get; set; }


        [BsonRequired]
        public string? CalendarId { get; set; }

        public CalendarEvent() { }

        // public CalendarEvent(CalendarEvent calendarEvent, ObjectId seriesId)
        // {
        //     Id = ObjectId.GenerateNewId();
        //     Location = calendarEvent.Location;
        //     Description = calendarEvent.Description;
        //     Start = calendarEvent.Start.ToUniversalTime();
        //     End = calendarEvent.End;
        //     LastUpdateDate = calendarEvent.LastUpdateDate.ToUniversalTime();
        //     CreatedDate = calendarEvent.CreatedDate.ToUniversalTime();
        //     LectureId = calendarEvent.LectureId;
        //     Repeat = calendarEvent.Repeat;
        //     SeriesId = seriesId;
        //     StartSeries = calendarEvent.StartSeries;
        //     EndSeries = calendarEvent.EndSeries;
        //     InstructorsIds = calendarEvent.InstructorsIds;
        //     CalendarId = calendarEvent.CalendarId;
        // }
    }
}