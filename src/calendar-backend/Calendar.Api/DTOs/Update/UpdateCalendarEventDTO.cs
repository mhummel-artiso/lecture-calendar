using Calendar.Api.DTOs.Create;

namespace Calendar.Api.DTOs.Update
{
    public class UpdateCalendarEventDTO : CreateCalendarEventDTO
    {
        public string? Id { get; set; }
    }
}
