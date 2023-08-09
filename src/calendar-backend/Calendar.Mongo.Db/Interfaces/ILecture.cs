namespace Calendar.Mongo.Db.Models;

public interface ILecture
{
    public string? Title { get; set; }
    public string? Description { get; set; }
    public string? ShortKey { get; set; }        
}