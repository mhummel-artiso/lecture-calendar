﻿using Calendar.Mongo.Db.Models;
using System.ComponentModel.DataAnnotations;

namespace Calendar.Api.DTOs.Update
{
    public class UpdateCalendarSeriesDTO
    {
        [Required]
        [StringLength(24, MinimumLength = 24)]
        public string? SeriesId { get; set; }

        [Required()]
        [StringLength(50)]
        public string? Location { get; set; }

        [StringLength(100)]
        public string? Description { get; set; }

        [Required()]
        public DateTimeOffset Start { get; set; }

        [Required()]
        public DateTimeOffset End { get; set; }

        [Required()]
        [Range(0, 3)]
        public EventRepeat Repeat { get; set; }

        [Required()]
        public DateTimeOffset StartSeries { get; set; }

        [Required()]
        public DateTimeOffset EndSeries { get; set; }

        public List<InstructorDTO>? Instructors { get; set; }

        [Required()]
        [StringLength(24, MinimumLength = 24)]
        public string? LectureId { get; set; }

        [Required()]
        public DateTimeOffset LastUpdateDate { get; set; }
    }
}