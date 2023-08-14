using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Api.DTOs.Create;
using Calendar.Api.DTOs.Update;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Profiles
{

    public class CalendarProfile : Profile
    {
        public CalendarProfile()
        {
            CreateMap<CreateUserCalendarDTO, UserCalendar>().ReverseMap();

            CreateMap<UpdateUserCalendarDTO, UserCalendar>().ReverseMap();

            CreateMap<UserCalendar, UserCalendarDTO>().ReverseMap();
        }
    }
}