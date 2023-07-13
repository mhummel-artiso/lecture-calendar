namespace Calendar.Maria.Db.Models
{
    public class StudentVintage
    {
        public Guid Id { get; set; }
        public string? Name { get; set; }
        public DateTime StartDate { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
