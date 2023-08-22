using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Services.Interfaces
{
    public interface ILectureService
    {
        Task<IEnumerable<Lecture>> GetLecturesAsync();
        Task<Lecture?> GetLectureByIdAsync(string lectureId);

        Task<Lecture> AddLectureAsync(Lecture lecture);

        Task<(Lecture? updatedLecture, bool hasConflict)> UpdateLectureAsync(string lectureId, Lecture lecture);

        Task<bool> DeleteLectureByIdAsync(string lectureId);
    }
}