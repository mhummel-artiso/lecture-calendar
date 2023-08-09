using Calendar.Mongo.Db.Models;
using System;

namespace Calendar.Api.Validation
{
    public static class EventValidator
    {
        public static void ValidateAddEvent(CalendarEvent calendarEvent)
        {
            if (calendarEvent.Rotation == EventRepeat.None) return;
            if (!calendarEvent.EndSeries.HasValue)
                throw new ArgumentException("If rotation is given, end series must also be given.");


            var serieEndDate = new DateTimeOffset(calendarEvent.EndSeries.Value.Year, calendarEvent.EndSeries.Value.Month, calendarEvent.EndSeries.Value.Day,
                    (calendarEvent.Start + calendarEvent.Duration).Hour, (calendarEvent.Start + calendarEvent.Duration).Minute,
                    (calendarEvent.Start + calendarEvent.Duration).Second, TimeSpan.Zero);

            if (serieEndDate < calendarEvent.Start) throw new ArgumentException("SerieEnd must be bigger than the start from the event.");

            if (calendarEvent.Rotation == EventRepeat.Daily && serieEndDate < calendarEvent.Start.AddDays(1))
                throw new ArgumentException("SerieEnd must for daily roatation at least one day bigger than event start");

            if (calendarEvent.Rotation == EventRepeat.Weekly && serieEndDate < calendarEvent.Start.AddDays(7))
                throw new ArgumentException("SerieEnd must for weekly rotation at least one week bigger than event start");

            if (calendarEvent.Rotation == EventRepeat.Monthly && serieEndDate < calendarEvent.Start.AddMonths(1))
                throw new ArgumentException("SerieEnd must for monthly rotation at least one month bigger than event start");
        }
    }
}