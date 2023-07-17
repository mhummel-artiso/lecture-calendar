using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using MongoDB.Driver;

namespace Calendar.Api.Services
{
    public class LectureService : ILectureService
    {
        private readonly IMongoCollection<Lecture> dbCollection;
        private readonly ILogger<ICalendarService> logger;

        public LectureService(ILogger<ICalendarService> logger, IMongoDatabase db)
        {
            this.logger = logger;
            dbCollection = db.GetCollection<Lecture>(nameof(Lecture));
            ArgumentNullException.ThrowIfNull(dbCollection);
        }

        public async Task AddLectureAsync(Lecture lecture)
        {
            throw new NotImplementedException();
        }

        public async Task<bool> DeleteLectureByIdAsync(string lectureId)
        {
            throw new NotImplementedException();
        }

        public async Task GetLectureByIdAsync(string lectureId)
        {
            throw new NotImplementedException();
        }

        public async Task UpdateLectureAsync(Lecture lecture)
        {
            throw new NotImplementedException();
        }
    }
}