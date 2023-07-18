using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces
{
    public interface ILectureService
    {
        Task<IEnumerable<Lecture>> GetLecturesAsync();
        Task<Lecture?> GetLectureByIdAsync(string lectureId);

        Task<Lecture> AddLectureAsync(Lecture lecture);

        Task<Lecture?> UpdateLectureAsync(string id, Lecture lecture);

        Task<bool> DeleteLectureByIdAsync(string lectureId);
    }
}