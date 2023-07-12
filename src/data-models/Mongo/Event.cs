﻿namespace data_models.Mongo
{
    public class Event
    {
        public int Id { get; set; }
        public DateTime Start { get; set; }
        public DateTime End { get; set; }
        public DateTime StartSeries { get; set; }
        public DateTime EndSeries { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
    }
}
