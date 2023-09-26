using Calendar.Mongo.Db.Models;
using Calendar.Api.Exceptions;

namespace Calendar.Api.Services.Interfaces
{
    public interface ILectureService
    {
        /// <summary>
        /// Get all lectures from database
        /// </summary>
        /// <returns>A collection of <see cref="Lecture"/></returns>
        Task<IEnumerable<Lecture>> GetLecturesAsync();

        /// <summary>
        /// Get specific lecture by id from database
        /// </summary>
        /// <param name="lectureId">Lecture ID</param>
        /// <returns><see cref="Lecture"/> or <see cref="null"/></returns>
        Task<Lecture?> GetLectureByIdAsync(string lectureId);

        /// <summary>
        /// Add a lecture to database
        /// </summary>
        /// <param name="lecture">New lecture to add</param>
        /// <returns><see cref="Lecture"/></returns>
        Task<Lecture> AddLectureAsync(Lecture lecture);

        /// <summary>
        /// Update a specific lecture from database
        /// </summary>
        /// <param name="lectureId">Lecture ID</param>
        /// <param name="lecture">Lecture with new values</param>
        /// <returns><see cref="Lecture"/></returns>
        /// <exception cref="KeyNotFoundException">There is no lecture with the lecture id.</exception>
        /// <exception cref="ConflictException{T}">lecture.LastUpdateDate is not the same as in the database.</exception>
        /// <exception cref="Exception">Problems while updating.</exception>
        Task<Lecture> UpdateLectureAsync(string lectureId, Lecture lecture);

        /// <summary>
        /// Delete a specific lecture from database
        /// </summary>
        /// <param name="lectureId">Lecture ID</param>
        /// <returns><see cref="bool"/></returns>
        /// <exception cref="ArgumentException">Throw because lectureID must not null.</exception>
        /// <exception cref="InvalidOperationException">Is thrown because there are still events with this lecture.</exception>
        Task<bool> DeleteLectureByIdAsync(string lectureId);
    }
}