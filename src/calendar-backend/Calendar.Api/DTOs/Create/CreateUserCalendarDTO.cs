using Calendar.Mongo.Db.Models;

namespace Calendar.Api.DTOs.Create
{
    public class CreateUserCalendarDTO:ICalendar
    {
        public string? Name { get; set; }
        public DateTimeOffset StartDate { get; set; }
    }
}
