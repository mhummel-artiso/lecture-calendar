namespace Calendar.Api.DTOs
{
    public class ReturnLectureDTO : UpdateLectureDTO
    {
        public DateTimeOffset CreatedDate { get; set; }
        public DateTimeOffset LastUpdateDate { get; set; }
    }
}
