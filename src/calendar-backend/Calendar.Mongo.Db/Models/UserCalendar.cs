using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace Calendar.Mongo.Db.Models
{
    public class UserCalendar : ICalendar
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public ObjectId Id { get; set; }
        public string Name { get; set; }
        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset StartDate { get; set; }
        public IList<CalendarEvent> Events { get; set; } = new List<CalendarEvent>();
        
        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset CreatedDate { get; set; }
        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset LastUpdateDate { get; set; }
    }
}