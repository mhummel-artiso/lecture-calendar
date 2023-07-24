using Calendar.Api.DTOs.Update;

namespace Calendar.Api.DTOs
{
    public class LectureDTO
    {
        public string? Id { get; set; }
        public string? Title { get; set; }
        public string? Comment { get; set; }
        public string? Professor { get; set; }
        public DateTimeOffset CreatedDate { get; set; }
        public DateTimeOffset LastUpdateDate { get; set; }
    }
}
