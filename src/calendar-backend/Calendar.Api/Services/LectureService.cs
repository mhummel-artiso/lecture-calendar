using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
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
            ArgumentNullException.ThrowIfNull(dbCollection);
        }
        public async Task<IEnumerable<Lecture>> GetLecturesAsync() =>
            await dbCollection.Find(x => true).ToListAsync();
        public async Task<Lecture?> GetLectureByIdAsync(string lectureId) =>
            await dbCollection.Find(x => x.Id == lectureId).FirstOrDefaultAsync();

        public async Task<Lecture> AddLectureAsync(Lecture lecture)
        {
            lecture.CreatedDate = DateTimeOffset.Now;
            await dbCollection.InsertOneAsync(lecture);
            return lecture;
        }
        public async Task<Lecture?> UpdateLectureAsync(string lectureId, Lecture lecture)
        {
            lecture.LastUpdateDate = DateTimeOffset.Now;
            var update = new UpdateDefinitionBuilder<Lecture>()
                .Set(x => x.Professor, lecture.Professor)
                .Set(x => x.Comment, lecture.Comment)
                .Set(x => x.Title, lecture.Title)
                .Set(x => x.LastUpdateDate, DateTimeOffset.UtcNow);
            var result = await dbCollection.UpdateOneAsync(x => x.Id == lectureId, update);
            return result.ModifiedCount == 1
                ? await dbCollection
                    .Find(x => x.Id == lectureId)
                    .FirstOrDefaultAsync()
                : null;
        }
        public async Task<bool> DeleteLectureByIdAsync(string lectureId)
        {
            var result = await dbCollection.DeleteOneAsync(x => x.Id == lectureId);
            return result.DeletedCount == 1;
        }
    }
}