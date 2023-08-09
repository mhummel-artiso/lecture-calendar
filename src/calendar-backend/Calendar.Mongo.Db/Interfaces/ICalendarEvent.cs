namespace Calendar.Mongo.Db.Models;

public interface ICalendarEvent
{
    string? Location { get; set; }
    string? Description { get; set; }
    DateTimeOffset Start { get; set; }
    Guid? SerieId { get; set; }
    EventRotation? Rotation { get; set; }
    List<Instructor>? InstructorsIds { get; set; }
    string? LectureId { get; set; }
}