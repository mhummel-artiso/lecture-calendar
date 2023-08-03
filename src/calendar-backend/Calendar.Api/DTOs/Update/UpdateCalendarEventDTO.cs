using Calendar.Api.DTOs.Create;
using MongoDB.Bson;
using System.ComponentModel.DataAnnotations;

namespace Calendar.Api.DTOs.Update
{
    public class UpdateCalendarEventDTO : CreateCalendarEventDTO
    {
        [Required()]
        [StringLength(24, MinimumLength = 24)]
        public string? Id { get; set; }
        
        [StringLength(24, MinimumLength = 24)]
        public string? SerieId { get; set; }
    }
}
