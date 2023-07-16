using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Profiles
{
    public class CalendarProfile : Profile
    {
        public CalendarProfile()
        {
            CreateMap<CreateCalendarDTO, UserCalendar>()
            .ForMember(
                dest => dest.Name,
                opt => opt.MapFrom(src => src.Name)
            )
            .ForMember(
                dest => dest.StartDate,
                opt => opt.MapFrom(src => src.StartDate)
            );

            CreateMap<UpdateCalendarDTO, UserCalendar>()
            .ForMember(
                dest => dest.Id,
                opt => opt.MapFrom(src => src.Id)
            )
            .ForMember(
                dest => dest.Name,
                opt => opt.MapFrom(src => src.Name)
            )
            .ForMember(
                dest => dest.StartDate,
                opt => opt.MapFrom(src => src.StartDate)
            );
        }
    }
}
