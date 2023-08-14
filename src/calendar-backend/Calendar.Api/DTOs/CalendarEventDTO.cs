﻿using Calendar.Api.Models;
using Calendar.Mongo.Db.Models;
using System.Text.Json.Serialization;
using Instructor = Calendar.Api.Models.Instructor;

namespace Calendar.Api.DTOs
{
    public class CalendarEventDTO
    {
        // Mapping
        public string? Id { get; set; }
        public string? Location { get; set; }
        public string? Description { get; set; }
        public DateTimeOffset Start { get; set; }
        public DateTimeOffset End { get; set; }
        public EventRotation? Rotation { get; set; }
        public string? SerieId { get; set; }
        public DateTimeOffset LastUpdateDate { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
        
        // Fill in controller
        public LectureDTO? Lecture { get; set; }
        public DateTimeOffset? StartSeries { get; set; }
        public DateTimeOffset? EndSeries { get; set; }
        public List<InstructorDTO>? Instructors { get; set; }

        [JsonIgnore]
        public List<string>? InstructorsIds { get; set; }

        [JsonIgnore]
        public string? LectureId { get; set; }
    }
}