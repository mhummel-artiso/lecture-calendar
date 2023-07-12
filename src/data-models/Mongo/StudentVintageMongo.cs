namespace data_models.Mongo
{
    public class StudentVintageMongo
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public DateTime StartDate { get; set; }
        public List<Lecture>? Lectures { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
