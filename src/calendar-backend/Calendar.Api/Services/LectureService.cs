using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using MongoDB.Bson;
using MongoDB.Driver;
using System.Globalization;

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
        public async Task<Lecture?> UpdateLectureAsync(string lectureId, Lecture lecture)
        {
            var update = new UpdateDefinitionBuilder<Lecture>()
                .Set(x => x.ShortKey, lecture.ShortKey)
                .Set(x => x.Description, lecture.Description)
                .Set(x => x.Title, lecture.Title)
                .Set(x => x.LastUpdateDate, DateTimeOffset.UtcNow);
            var result = await dbCollection.UpdateOneAsync(x => x.Id == new ObjectId(lectureId), update);
            return result.ModifiedCount == 1
                ? await dbCollection
                    .Find(x => x.Id == new ObjectId(lectureId))
                    .FirstOrDefaultAsync()
                : null;
        }
        public async Task<bool> DeleteLectureByIdAsync(string lectureId)
        {
            var result = await dbCollection.DeleteOneAsync(x => x.Id == new ObjectId(lectureId));
            return result.DeletedCount == 1;
        }
    }
}