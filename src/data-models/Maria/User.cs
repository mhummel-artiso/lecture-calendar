namespace data_models.Maria
{
    public class User
    {
        public int Id { get; set; }
        public string? Email { get; set; }
        public string? Name { get; set; }
        public string? Password { get; set; }
        public Role? Role { get; set; }
        public List<StudentVintage>? Courses { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
