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

        public async Task<IEnumerable<Lecture>> GetAllLecturesFromCalendarAsync(string calendarId) => throw new NotImplementedException();
        public async Task<IEnumerable<Lecture>> GetLecturesByCalendarNameAsync(string calendarName) => throw new NotImplementedException();
        public async Task<IEnumerable<Lecture>> GetLecturesWeekSectionAsync(string calendarName, int weekNumber, int year) => throw new NotImplementedException();
        public async Task<IEnumerable<Lecture>> GetLecturesDaySectionAsync(string calendarName, DateTime date) => throw new NotImplementedException();
        public async Task AddLectureAsync(Lecture lecture, string calendarId) => throw new NotImplementedException();
        public async Task UpdateLectureAsync(Lecture lecture, string calendarName) => throw new NotImplementedException();
        public async Task<bool> DeleteLectureByIdAsync(string id) => throw new NotImplementedException();
    }
}