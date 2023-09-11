using Calendar.Api.DTOs.Create;
using System.ComponentModel.DataAnnotations;

namespace Calendar.Api.DTOs.Update
{
    public class UpdateUserCalendarDTO : CreateUserCalendarDTO
    {
        [Required()]
        [StringLength(24, MinimumLength = 24)]
        public string? Id { get; set; }
        [Required()]
        public DateTimeOffset LastUpdateDate { get; set; }
    }
}
