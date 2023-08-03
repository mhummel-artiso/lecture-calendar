using Calendar.Mongo.Db.Models;
using System;

namespace Calendar.Api.Services.Validation
{
    public static class EventValidationService
    {
        public static void ValidateAddEvent(CalendarEvent calendarEvent, DateTimeOffset? serieEnd)
        {
            if (calendarEvent.End <  calendarEvent.Start) throw new ArgumentException("The end of the event is before the start of the event.");

            if((serieEnd.HasValue && !calendarEvent.Rotation.HasValue) || (!serieEnd.HasValue && calendarEvent.Rotation.HasValue)) throw new ArgumentException("If serieEnd is given, rotation must also be given, and also the other way around.");

            if(serieEnd.HasValue && calendarEvent.Rotation.HasValue)
            {
                var serieEndDate = new DateTimeOffset(serieEnd.Value.Year, serieEnd.Value.Month, serieEnd.Value.Day, calendarEvent.End.Hour, calendarEvent.End.Minute, calendarEvent.End.Second, TimeSpan.Zero);

                if (serieEndDate < calendarEvent.Start) throw new ArgumentException("SerieEnd must be bigger than the start from the event.");

                if (calendarEvent.Rotation == EventRotation.Daily && serieEndDate < calendarEvent.Start.AddDays(1)) throw new ArgumentException("SerieEnd must for daily roatation at least one day bigger than event start");

                if (calendarEvent.Rotation == EventRotation.Weekly && serieEndDate < calendarEvent.Start.AddDays(7)) throw new ArgumentException("SerieEnd must for weekly rotation at least one week bigger than event start");

                if (calendarEvent.Rotation == EventRotation.Monthly && serieEndDate < calendarEvent.Start.AddMonths(1)) throw new ArgumentException("SerieEnd must for monthly rotation at least one month bigger than event start");
            }
        }
    }
}
