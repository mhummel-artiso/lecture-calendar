using MongoDB.Bson.Serialization.Attributes;

namespace Calendar.Mongo.Db.Models
{
    public class Lecture
    {
        [BsonId]
        [BsonRepresentation(MongoDB.Bson.BsonType.ObjectId)]
        public string? Id { get; set; }
        public string? Title { get; set; }
        public string? Comment { get; set; }
        public string? Professor { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
        public DateTimeOffset LastUpdateDate { get; set; }
    }
}
