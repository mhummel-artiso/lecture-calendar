namespace Calendar.Api.Extensions
{
    public static class DateTimeOffsetExtensions
    {
        public static DateTimeOffset TrimMilliseconds(this DateTimeOffset dt)
        {
            return new DateTimeOffset(dt.Year, dt.Month, dt.Day, dt.Hour, dt.Minute, dt.Second, 0, TimeSpan.Zero);
        }
    }
}
