using Calendar.Mongo.Db.Models;
using System;

namespace Calendar.Api.Services.Validation
{
    public static class EventValidationService
    {
        public static void ValidateAddEvent(CalendarEvent calendarEvent)
        {

            if((calendarEvent.EndSeries.HasValue && !calendarEvent.Rotation.HasValue) || (!calendarEvent.EndSeries.HasValue && calendarEvent.Rotation.HasValue)) throw new ArgumentException("If serieEnd is given, rotation must also be given, and also the other way around.");

            if(calendarEvent.EndSeries.HasValue && calendarEvent.Rotation.HasValue)
            {
                var serieEndDate = new DateTimeOffset(calendarEvent.EndSeries.Value.Year, calendarEvent.EndSeries.Value.Month, calendarEvent.EndSeries.Value.Day, (calendarEvent.Start + calendarEvent.Duration).Hour, (calendarEvent.Start + calendarEvent.Duration).Minute, (calendarEvent.Start + calendarEvent.Duration).Second, TimeSpan.Zero);

                if (serieEndDate < calendarEvent.Start) 
                    throw new ArgumentException("SerieEnd must be bigger than the start from the event.");

                if (calendarEvent.Rotation == EventRotation.Daily && serieEndDate < calendarEvent.Start.AddDays(1)) 
                    throw new ArgumentException("SerieEnd must for daily roatation at least one day bigger than event start");

                if (calendarEvent.Rotation == EventRotation.Weekly && serieEndDate < calendarEvent.Start.AddDays(7)) 
                    throw new ArgumentException("SerieEnd must for weekly rotation at least one week bigger than event start");

                if (calendarEvent.Rotation == EventRotation.Monthly && serieEndDate < calendarEvent.Start.AddMonths(1)) 
                    throw new ArgumentException("SerieEnd must for monthly rotation at least one month bigger than event start");
            }
        }
    }
}
