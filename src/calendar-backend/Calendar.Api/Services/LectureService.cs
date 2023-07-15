using Calendar.Api.Services.Interfaces;
using Calendar.Mongo.Db.Models;
using MongoDB.Driver;

namespace Calendar.Api.Services
{
    public class LectureService : ILectureService
    {
        private readonly IMongoCollection<Mongo.Db.Models.Calendar> calendarCollection;
        private readonly ILogger<ICalendarService> logger;

        public LectureService(ILogger<ICalendarService> logger, IMongoCollection<Mongo.Db.Models.Calendar> calendarCollection)
        {
            if (logger == null) throw new ArgumentNullException(nameof(logger));
            if (calendarCollection == null) throw new ArgumentNullException(nameof(calendarCollection));

            this.logger = logger;
            this.calendarCollection = calendarCollection;
        }

        public Task AddLectureAsync(Lecture lecture, string calendarId)
        {
            throw new NotImplementedException();
        }

        public Task DeleteLectureByIdAsync(string id)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<Lecture>> GetLecturesByCalendarIdAsync(string calendarId)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<Lecture>> GetLecturesByCalendarNameAsync(string calendarName)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<Lecture>> GetLecturesDaySectionAsync(string calendarName, DateTime date)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<Lecture>> GetLecturesWeekSectionAsync(string calendarName, int weekNumber, int year)
        {
            throw new NotImplementedException();
        }

        public Task UpdateLectureAsync(Lecture lecture, string calendarName)
        {
            throw new NotImplementedException();
        }
    }
}
