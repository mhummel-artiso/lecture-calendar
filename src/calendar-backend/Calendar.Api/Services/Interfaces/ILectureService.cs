using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces
{
    public interface ILectureService
    {
        Task<IEnumerable<Lecture>> GetLecturesByCalendarIdAsync(string calendarId);
        Task<IEnumerable<Lecture>> GetLecturesByCalendarNameAsync(string calendarName);
        Task<IEnumerable<Lecture>> GetLecturesWeekSectionAsync(string calendarName, int weekNumber, int year);
        Task<IEnumerable<Lecture>> GetLecturesDaySectionAsync(string calendarName, DateTime date);

        Task AddLectureAsync(Lecture lecture, string calendarId);

        Task UpdateLectureAsync(Lecture lecture, string calendarName);

        Task DeleteLectureByIdAsync(string id);
    }
}
