using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Profiles
{
    public class CalendarProfile : Profile
    {
        public CalendarProfile()
        {
            CreateMap<CreateCalendarDTO, UserCalendar>().ReverseMap();

            CreateMap<UpdateCalendarDTO, UserCalendar>().ReverseMap();

            CreateMap<UserCalendar, ReturnCalendarDTO>().ReverseMap();
        }
    }
}
