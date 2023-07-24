using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Api.DTOs.Create;
using Calendar.Api.DTOs.Update;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Profiles
{
    public class EventProfile : Profile
    {
        public EventProfile()
        {
            CreateMap<CreateCalendarEventDTO, CalendarEvent>().ReverseMap();

            CreateMap<UpdateCalendarEventDTO, CalendarEvent>().ReverseMap();

            CreateMap<CalendarEvent, CalendarEventDTO>().ReverseMap();
        }
    }
}
