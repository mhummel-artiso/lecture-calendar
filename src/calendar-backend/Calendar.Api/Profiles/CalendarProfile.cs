using AutoMapper;
using Calendar.Mongo.Db.DTOs;

namespace Calendar.Api.Profiles
{
    public class CalendarProfile : Profile
    {
        public CalendarProfile()
        {
            CreateMap<CreateCalendarDTO, Mongo.Db.Models.Calendar>()
            .ForMember(
                dest => dest.Name,
                opt => opt.MapFrom(src => src.Name)
            )
            .ForMember(
                dest => dest.StartDate,
                opt => opt.MapFrom(src => src.StartDate)
            );

            CreateMap<UpdateCalendarDTO, Mongo.Db.Models.Calendar>()
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
