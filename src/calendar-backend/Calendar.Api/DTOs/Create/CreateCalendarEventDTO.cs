using Calendar.Mongo.Db.Models;
using MongoDB.Bson;
using System.ComponentModel.DataAnnotations;

namespace Calendar.Api.DTOs.Create
{
    public class CreateCalendarEventDTO : ICalendarEvent
    {
        [Required()]
        [StringLength(50)]
        public string? Location { get; set; }

        [StringLength(100)]
        public string? Description { get; set; }

        [Required()]
        public DateTimeOffset Start { get; set; }

        [Required()]
        public DateTimeOffset End { get; set; }

        public List<string>? InstructorsIds { get; set; }

        [Range(0, 3)]
        public EventRotation Rotation { get; set; }

        public DateTimeOffset? EndSeries { get; set; }

        [Required()]
        [StringLength(24, MinimumLength = 24)]
        public string? LectureId { get; set; }
    }
}