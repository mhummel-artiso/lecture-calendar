using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Profiles
{
    public class LectureProfile : Profile
    {
        public LectureProfile()
        {
            CreateMap<CreateLectureDTO, Lecture>()
            .ForMember(
                dest => dest.Professor,
                opt => opt.MapFrom(src => src.Professor)
            )
            .ForMember(
                dest => dest.Comment,
                opt => opt.MapFrom(src => src.Comment)
            )
            .ForMember(
                dest => dest.Title,
                opt => opt.MapFrom(src => src.Title)
            );

            CreateMap<UpdateLectureDTO, Lecture>()
            .ForMember(
                dest => dest.Id,
                opt => opt.MapFrom(src => src.Id)
            )
            .ForMember(
                dest => dest.Professor,
                opt => opt.MapFrom(src => src.Professor)
            )
            .ForMember(
                dest => dest.Comment,
                opt => opt.MapFrom(src => src.Comment)
            )
            .ForMember(
                dest => dest.Title,
                opt => opt.MapFrom(src => src.Title)
            );
        }
    }
}
