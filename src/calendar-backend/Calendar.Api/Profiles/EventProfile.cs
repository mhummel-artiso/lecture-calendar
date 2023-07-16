using AutoMapper;
using Calendar.Mongo.Db.DTOs;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Profiles
{
    public class EventProfile : Profile
    {
        public EventProfile()
        {
            CreateMap<CreateEventDTO, Event>().ReverseMap();

            CreateMap<UpdateEventDTO, Event>().ReverseMap();
        }
    }
}
