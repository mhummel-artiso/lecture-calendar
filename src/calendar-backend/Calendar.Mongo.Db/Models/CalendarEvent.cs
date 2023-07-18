using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace Calendar.Mongo.Db.Models
{
    public class CalendarEvent
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string? Id { get; set; }
        public string? Location { get; set; }
        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset Start { get; set; }
        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset End { get; set; }
        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset StartSeries { get; set; }
        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset EndSeries { get; set; }
        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset CreatedDate { get; set; }
        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset LastUpdateDate { get; set; }
        public string? LectureId { get; set; }
    }
}