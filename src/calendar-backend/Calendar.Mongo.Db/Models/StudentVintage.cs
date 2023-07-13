namespace Calendar.Mongo.Db.Models
{
    public class StudentVintage
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public DateTime StartDate { get; set; }
        public List<Lecture>? Lectures { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
