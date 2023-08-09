using AutoMapper;
using Calendar.Api.DTOs;
using Calendar.Api.DTOs.Create;
using Calendar.Api.DTOs.Update;
using Calendar.Mongo.Db.Models;
using MongoDB.Bson;

namespace Calendar.Api.Profiles
{
    public class EventProfile : Profile
    {
        public EventProfile()
        {
            CreateMap<CreateCalendarEventDTO, CalendarEvent>()
                .ForMember(x => x.Start, opt => opt.MapFrom(src => src.Start.ToUniversalTime()))
                .ForMember(x => x.EndSeries, opt => opt.MapFrom(src => src.EndSeries.HasValue ? src.EndSeries.Value.ToUniversalTime() : src.EndSeries))
                // not generate ids by api
                .ForMember(x => x.Id, opt => opt.NullSubstitute(ObjectId.GenerateNewId()))
                .ForMember(x => x.StartSeries, opt => opt.MapFrom(src => src.Start.ToUniversalTime()))
                .ForMember(x => x.Duration, opt =>
                {
                    opt.Condition(x => x.End.ToUniversalTime() >= x.Start.ToUniversalTime());
                    opt.MapFrom(src => src.End.ToUniversalTime() - src.Start.ToUniversalTime());
                })
                .ForMember(x => x.LectureId, opts =>
                {
                    opts.DoNotAllowNull();
                    opts.Condition(x => x.LectureId?.Length == 24);
                });

            CreateMap<UpdateCalendarSerieDTO, CalendarEvent>()
                .ForMember(x => x.Start, opt => opt.MapFrom(src => src.Start.ToUniversalTime()))
                .ForMember(x => x.Duration, opt =>
                {
                    opt.Condition(x => x.End.ToUniversalTime() >= x.Start.ToUniversalTime());
                    opt.MapFrom(src => src.End.ToUniversalTime() - src.Start.ToUniversalTime());
                })
                .ForMember(x => x.EndSeries, opt => opt.MapFrom(src => src.EndSeries.ToUniversalTime()))
                .ForMember(x => x.StartSeries, opt => opt.MapFrom(src => src.Start.ToUniversalTime()));


            CreateMap<UpdateCalendarEventDTO, CalendarEvent>()
                .ForMember(x => x.Start, opt => opt.MapFrom(src => src.Start.ToUniversalTime()))
                .ForMember(x => x.Duration, opt =>
                {
                    opt.Condition(x => x.End.ToUniversalTime() >= x.Start.ToUniversalTime());
                    opt.MapFrom(src => src.End.ToUniversalTime() - src.Start.ToUniversalTime());
                });


            CreateMap<CalendarEvent, CalendarEventDTO>()
                .ForMember(x => x.End, opt => opt.MapFrom(src => src.Start + src.Duration));
        }
    }
}