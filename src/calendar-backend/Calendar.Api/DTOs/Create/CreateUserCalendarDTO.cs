namespace Calendar.Api.DTOs.Create
{
    public class CreateUserCalendarDTO
    {
        public string? Name { get; set; }
        public DateTimeOffset StartDate { get; set; }
    }
}
