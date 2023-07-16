using MongoDB.Bson.Serialization.Attributes;

namespace Calendar.Mongo.Db.Models
{
    public class UserCalendar
    {
        [BsonId]
        [BsonRepresentation(MongoDB.Bson.BsonType.ObjectId)]
        public string? Id { get; set; }
        public string? Name { get; set; }   
        public DateTime StartDate { get; set; }
        public List<CalendarEvent>? Events { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}