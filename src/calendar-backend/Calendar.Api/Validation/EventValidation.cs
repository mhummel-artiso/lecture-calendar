using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Validation
{
    public static class EventValidator
    {
        public static CalendarEvent ValidateLocation(this CalendarEvent calendarEvent)
        {
            ArgumentException.ThrowIfNullOrEmpty(calendarEvent.Location);
            return calendarEvent;
        }
        public static CalendarEvent ValidateSeriesId(this CalendarEvent calendarEvent)
        {
            ArgumentNullException.ThrowIfNull(calendarEvent.SeriesId);
            return calendarEvent;
        }
        public static CalendarEvent ValidateCalendarId(this CalendarEvent calendarEvent)
        {
            ArgumentException.ThrowIfNullOrEmpty(calendarEvent.CalendarId);
            return calendarEvent;
        }
        public static CalendarEvent ValidateSeriesTimes(this CalendarEvent calendarEvent)
        {
            if (calendarEvent.Repeat == EventRepeat.None)
                return calendarEvent;

            var endSeries = calendarEvent.EndSeries ?? throw new ArgumentException("If repeat is set, the end of the series must also be set.");
            
            var startSeries = calendarEvent.StartSeries ?? throw new ArgumentException("If repeat is set, the start of the series must also be set.");
            
            var seriesEndDate = new DateTimeOffset(endSeries.Year, endSeries.Month, endSeries.Day, startSeries.Hour, startSeries.Minute, startSeries.Second, 0, TimeSpan.Zero);

            var seriesStartDate = new DateTimeOffset(startSeries.Year, startSeries.Month, startSeries.Day, calendarEvent.Start.Hour, calendarEvent.Start.Minute, calendarEvent.Start.Second, 0, TimeSpan.Zero);

            if (seriesEndDate < startSeries)
                throw new ArgumentException($"{nameof(calendarEvent.EndSeries)} must be bigger than the {nameof(calendarEvent.StartSeries)} from the event.");

            if (calendarEvent.Repeat == EventRepeat.Daily && seriesEndDate < seriesStartDate.AddDays(1))
                throw new ArgumentException($"{nameof(calendarEvent.EndSeries)} must for daily repeat at least one day bigger than event start");

            if (calendarEvent.Repeat == EventRepeat.Weekly && seriesEndDate < seriesStartDate.AddDays(7))
                throw new ArgumentException($"{nameof(calendarEvent.EndSeries)} must for weekly repeat at least one week bigger than event start");
            
            if (calendarEvent.Repeat == EventRepeat.Monthly && seriesEndDate < seriesStartDate.AddDays(28))
                throw new ArgumentException($"{nameof(calendarEvent.EndSeries)} must for monthly repeat at least one month bigger than event start");
            return calendarEvent;
        }
    }
}