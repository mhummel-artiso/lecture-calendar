namespace Calendar.Maria.Db.Models
{
    public class User
    {
        public Guid Id { get; set; }
        public string? Email { get; set; }
        public string? Name { get; set; }
        public string? Password { get; set; }
        public Role? Role { get; set; }
        public List<StudentClass>? Vintages { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
