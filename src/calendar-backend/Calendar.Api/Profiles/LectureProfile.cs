using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Profiles
{
    public class LectureProfile : Profile
    {
        public LectureProfile()
        {
            CreateMap<CreateLectureDTO, Lecture>().ReverseMap();

            CreateMap<UpdateLectureDTO, Lecture>().ReverseMap();

            CreateMap<Lecture, ReturnLectureDTO>().ReverseMap();
        }
    }
}
