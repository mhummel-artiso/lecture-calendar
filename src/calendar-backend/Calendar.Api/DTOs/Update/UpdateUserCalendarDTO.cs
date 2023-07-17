using Calendar.Api.DTOs.Create;

namespace Calendar.Api.DTOs.Update
{
    public class UpdateUserCalendarDTO : CreateUserCalendarDTO
    {
        public string? Id { get; set; }
    }
}
