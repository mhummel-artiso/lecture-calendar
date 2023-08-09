namespace Calendar.Mongo.Db.Models;

public class ICalendar
{
    string Name { get; set; }
    DateTimeOffset StartDate { get; set; }
    DateTimeOffset CreatedDate { get; set; }
}