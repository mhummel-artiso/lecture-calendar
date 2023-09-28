using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Api.DTOs.Create;
using Calendar.Api.DTOs.Update;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Profiles
{

    /* The CalendarProfile class is responsible for mapping between different data transfer objects and
    the UserCalendar entity. */
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