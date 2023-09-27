namespace Calendar.Mongo.Db.Interfaces;

public class ICalendar
{
    string Name { get; set; }
    DateTimeOffset StartDate { get; set; }
}