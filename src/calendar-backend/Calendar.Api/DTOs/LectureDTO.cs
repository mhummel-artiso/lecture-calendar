using Calendar.Api.DTOs.Update;
using Calendar.Mongo.Db.Interfaces;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.DTOs
{
    public class LectureDTO:ILecture

    {
    public string? Id { get; set; }
    public string? Title { get; set; }
    public string? Description { get; set; }
    public string? ShortKey { get; set; }
    public DateTimeOffset CreatedDate { get; set; }
    public DateTimeOffset? LastUpdateDate { get; set; }
    }
}
