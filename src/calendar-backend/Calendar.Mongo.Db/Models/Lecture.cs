namespace Calendar.Mongo.Db.Models
{
    public class Lecture
    {
        public int Id { get; set; }
        public string? Title { get; set; }
        public string? Comment { get; set; }
        public string? Professor { get; set; }
        public List<Event>? Events { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
