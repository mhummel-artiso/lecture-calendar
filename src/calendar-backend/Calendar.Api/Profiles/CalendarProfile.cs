using AutoMapper;
using Calendar.Mongo.Db.DTOs;

namespace Calendar.Api.Profiles
{
    public class CalendarProfile : Profile
    {
        public CalendarProfile()
        {
            CreateMap<CreateCalendarDTO, Mongo.Db.Models.Calendar>().ReverseMap();

            CreateMap<UpdateCalendarDTO, Mongo.Db.Models.Calendar>().ReverseMap();
        }
    }
}
