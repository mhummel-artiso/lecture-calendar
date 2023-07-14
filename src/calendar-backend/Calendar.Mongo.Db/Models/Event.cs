﻿namespace Calendar.Mongo.Db.Models
{
    public class Event
    {
        public Guid Id { get; set; }
        public string? Location { get; set; }
        public DateTimeOffset Start { get; set; }
        public DateTimeOffset End { get; set; }
        public DateTimeOffset StartSeries { get; set; }
        public DateTimeOffset EndSeries { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
        public DateTimeOffset LastUpdateDate { get; set; }
    }
}