namespace Calendar.Maria.Db.Models
{
    public class Role
    {
        public Guid Id { get; set; }
        public string? Name { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
