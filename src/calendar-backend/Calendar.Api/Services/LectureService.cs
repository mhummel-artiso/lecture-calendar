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
            calendarCollection = db.GetCollection<UserCalendar>(nameof(UserCalendar));
            ArgumentNullException.ThrowIfNull(dbCollection);
        }
        public async Task<IEnumerable<Lecture>> GetLecturesAsync() =>
            await dbCollection.Find(x => true).ToListAsync();
        public async Task<Lecture?> GetLectureByIdAsync(string lectureId) =>
            await dbCollection.Find(x => x.Id == lectureId).FirstOrDefaultAsync();

        public async Task<Lecture> AddLectureAsync(Lecture lecture)
        {
            await dbCollection.InsertOneAsync(lecture);
            return lecture;
        }
        public async Task<Lecture?> UpdateLectureAsync(string id, Lecture lecture)
        {
            var result = await dbCollection.ReplaceOneAsync(x => x.Id == id, lecture);
            return result.IsModifiedCountAvailable ? lecture : null;
        }
        public async Task<bool> DeleteLectureByIdAsync(string lectureId)
        {

            var result = await dbCollection.DeleteOneAsync(x => x.Id == lectureId);
            return result.DeletedCount == 1;
        }
    }
}