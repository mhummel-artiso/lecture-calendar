﻿using AutoMapper;
using Calendar.Mongo.Db.DTOs;
using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Profiles
{
    public class EventProfile : Profile
    {
        public EventProfile()
        {
            CreateMap<CreateEventDTO, Event>()
            .ForMember(
                dest => dest.Location,
                opt => opt.MapFrom(src => src.Location)
            )
            .ForMember(
                dest => dest.Start,
                opt => opt.MapFrom(src => src.Start)
            )
            .ForMember(
                dest => dest.End,
                opt => opt.MapFrom(src => src.End)
            )
            .ForMember(
                dest => dest.Start,
                opt => opt.MapFrom(src => src.StartSeries)
            )
            .ForMember(
                dest => dest.Start,
                opt => opt.MapFrom(src => src.EndSeries)
            );

            CreateMap<UpdateEventDTO, Event>()
            .ForMember(
                dest => dest.Id,
                opt => opt.MapFrom(src => src.Id)
            )
            .ForMember(
                dest => dest.Location,
                opt => opt.MapFrom(src => src.Location)
            )
            .ForMember(
                dest => dest.Start,
                opt => opt.MapFrom(src => src.Start)
            )
            .ForMember(
                dest => dest.End,
                opt => opt.MapFrom(src => src.End)
            )
            .ForMember(
                dest => dest.Start,
                opt => opt.MapFrom(src => src.StartSeries)
            )
            .ForMember(
                dest => dest.Start,
                opt => opt.MapFrom(src => src.EndSeries)
            );
        }
    }
}
