namespace data_models.Maria
{
    public class Course
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public DateTime StartDate { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
