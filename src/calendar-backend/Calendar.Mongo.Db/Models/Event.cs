namespace Calendar.Mongo.Db.Models
{
    public class Event
    {
        public Guid Id { get; set; }
        public DateTime Start { get; set; }
        public DateTime End { get; set; }
        public DateTime StartSeries { get; set; }
        public DateTime EndSeries { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}