﻿using Calendar.Api.Exceptions;
using Calendar.Api.Extensions;
using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using MongoDB.Driver;

namespace Calendar.Api.Services
{
    public class LectureService : ILectureService
    {
        private readonly IMongoCollection<Lecture> dbCollection;
        private readonly IMongoCollection<UserCalendar> calendarCollection;
        private readonly ILogger<ICalendarService> logger;

        public LectureService(ILogger<ICalendarService> logger, IMongoDatabase db)
        {
            this.logger = logger;
            dbCollection = db.GetCollection<Lecture>(nameof(Lecture));
            calendarCollection = db.GetCollection<UserCalendar>(nameof(UserCalendar));
            ArgumentNullException.ThrowIfNull(dbCollection);
        }
        public async Task<IEnumerable<Lecture>> GetLecturesAsync() =>
            await dbCollection.Find(x => true).ToListAsync();
        public async Task<Lecture?> GetLectureByIdAsync(string lectureId) =>
            await dbCollection.Find(x => x.Id == new ObjectId(lectureId)).FirstOrDefaultAsync();

        public async Task<Lecture> AddLectureAsync(Lecture lecture)
        {
            lecture.CreatedDate = DateTimeOffset.UtcNow;
            lecture.LastUpdateDate = DateTimeOffset.UtcNow;
            await dbCollection.InsertOneAsync(lecture);
            return lecture;
        }
        public async Task<Lecture> UpdateLectureAsync(string lectureId, Lecture lecture)
        {
            var lectureToUpdate = await dbCollection.Find(x => x.Id == new ObjectId(lectureId)).FirstOrDefaultAsync();

            if (lectureToUpdate == null) throw new KeyNotFoundException("Lecture was not found.");

            // Check for conflict.
            if (lectureToUpdate.LastUpdateDate.TrimMilliseconds() != lecture.LastUpdateDate.TrimMilliseconds()) throw new ConflictException<Lecture>(lecture);

            lecture.LastUpdateDate = DateTimeOffset.UtcNow;
            lecture.CreatedDate = lectureToUpdate.CreatedDate;
            var update = new UpdateDefinitionBuilder<Lecture>()
                .Set(x => x.ShortKey, lecture.ShortKey)
                .Set(x => x.Description, lecture.Description)
                .Set(x => x.Title, lecture.Title)
                .Set(x => x.LastUpdateDate, lecture.LastUpdateDate);
            
            var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(lectureId), update);
            return result.ModifiedCount == 1 ? lecture : throw new Exception("Problem with updating lecture");
        }
        public async Task<bool> DeleteLectureByIdAsync(string lectureId)
        {
            ArgumentException.ThrowIfNullOrEmpty(lectureId);

            if(calendarCollection != null)
            {
                // check if there are existing events with this lecture
                FilterDefinition<UserCalendar> filter = Builders<UserCalendar>.Filter.ElemMatch(x => x.Events, e => e.LectureId == lectureId);
                var lectureResult = calendarCollection.Find(filter).Any();

                if (lectureResult == true)
                {
                    throw new InvalidOperationException("Cannot delete lecture");
                }
            }
            var result = await dbCollection.DeleteOneAsync(x => x.Id == new ObjectId(lectureId));
            return result.DeletedCount == 1;
        }
    }
}