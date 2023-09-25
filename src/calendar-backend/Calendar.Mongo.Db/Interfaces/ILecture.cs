namespace Calendar.Mongo.Db.Interfaces;

public interface ILecture
{
    string? Title { get; set; }
    string? Description { get; set; }
    string? ShortKey { get; set; }
}