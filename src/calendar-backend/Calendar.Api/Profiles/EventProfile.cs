using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Profiles
{
    public class EventProfile : Profile
    {
        public EventProfile()
        {
            CreateMap<CreateEventDTO, CalendarEvent>().ReverseMap();

            CreateMap<UpdateEventDTO, CalendarEvent>().ReverseMap();

            CreateMap<CalendarEvent, ReturnEventDTO>().ReverseMap();
        }
    }
}
