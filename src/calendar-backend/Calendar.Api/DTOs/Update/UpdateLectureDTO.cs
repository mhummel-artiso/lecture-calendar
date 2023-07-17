using Calendar.Api.DTOs.Create;

namespace Calendar.Api.DTOs.Update
{
    public class UpdateLectureDTO : CreateLectureDTO
    {
        public string? Id { get; set; }
    }
}
