using MongoDB.Bson;

namespace Calendar.Mongo.Db.Models;

public interface ICalendarEvent
{
    string? Location { get; set; }
    string? Description { get; set; }
    DateTimeOffset Start { get; set; }
    // ObjectId? SerieId { get; set; }
    EventRotation Rotation { get; set; }
    List<string>? InstructorsIds { get; set; }
    string? LectureId { get; set; }
}