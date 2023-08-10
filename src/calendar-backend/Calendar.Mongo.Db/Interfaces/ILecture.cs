namespace Calendar.Mongo.Db.Models;

public interface ILecture
{
    string? Title { get; set; }
    string? Description { get; set; }
    string? ShortKey { get; set; }
}