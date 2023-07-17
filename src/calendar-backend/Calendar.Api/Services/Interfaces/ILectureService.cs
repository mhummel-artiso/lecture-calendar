using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces
{
    public interface ILectureService
    {
        Task GetLectureByIdAsync(string lectureId);

        Task<Lecture> AddLectureAsync(Lecture lecture);

        Task<Lecture> UpdateLectureAsync(Lecture lecture);

        Task<bool> DeleteLectureByIdAsync(string lectureId);
    }
}
