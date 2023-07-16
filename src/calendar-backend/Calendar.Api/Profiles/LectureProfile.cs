using AutoMapper;
using Calendar.Mongo.Db.DTOs;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Profiles
{
    public class LectureProfile : Profile
    {
        public LectureProfile()
        {
            CreateMap<CreateLectureDTO, Lecture>().ReverseMap();

            CreateMap<UpdateLectureDTO, Lecture>().ReverseMap();
        }
    }
}
