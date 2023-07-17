using Calendar.Mongo.Db.Models;

namespace Calendar.Api.DTOs
{
    public class ReturnCalendarDTO : UpdateCalendarDTO
    {
        public List<ReturnEventDTO>? Events { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
