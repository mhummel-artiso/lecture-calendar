using Calendar.Mongo.Db.Models;

namespace Calendar.Api.DTOs
{
    public class ReturnEventDTO : UpdateEventDTO
    {
        public DateTimeOffset CreatedDate { get; set; }
        public DateTimeOffset LastUpdateDate { get; set; }
        public Lecture? Lecture { get; set; }
    }
}
