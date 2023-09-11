namespace Calendar.Api.Utilities.ExtensionMethods
{
    public static class DateTimeOffsetExtionMethods
    {
        public static DateTimeOffset TrimMilliseconds(this DateTimeOffset dt)
        {
            return new DateTimeOffset(dt.Year, dt.Month, dt.Day, dt.Hour, dt.Minute, dt.Second, 0, TimeSpan.Zero);
        }
    }
}
