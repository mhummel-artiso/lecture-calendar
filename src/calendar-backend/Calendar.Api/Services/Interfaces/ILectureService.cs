using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces
{
    public interface ILectureService
    {
        Task GetLectureByIdAsync(string lectureId);

        Task AddLectureAsync(Lecture lecture);

        Task UpdateLectureAsync(Lecture lecture);

        Task<bool> DeleteLectureByIdAsync(string lectureId);
    }
}
