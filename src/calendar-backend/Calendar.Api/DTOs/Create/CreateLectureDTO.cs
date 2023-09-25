using Calendar.Mongo.Db.Interfaces;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.DTOs.Create
{
    public class CreateLectureDTO : ILecture
    {
        public string? Title { get; set; }
        public string? Description { get; set; }
        public string? ShortKey { get; set; }
    }
}