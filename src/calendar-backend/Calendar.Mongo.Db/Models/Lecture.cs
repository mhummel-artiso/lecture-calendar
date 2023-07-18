using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace Calendar.Mongo.Db.Models
{
    public class Lecture
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string? Id { get; set; }
        public string? Title { get; set; }
        public string? Comment { get; set; }
        public string? Professor { get; set; }
        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset CreatedDate { get; set; }
        [BsonRepresentation(BsonType.String)]
        public DateTimeOffset LastUpdateDate { get; set; }
    }
}
