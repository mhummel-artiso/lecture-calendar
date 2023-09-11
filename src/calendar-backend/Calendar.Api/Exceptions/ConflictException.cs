using Calendar.Mongo.Db.Models;

namespace Calendar.Api.Exceptions
{
    public class ConflictException<T> : Exception
    {
        public T NewestEvent { get; init; }
        public ConflictException(T newestEvent) 
        {
            NewestEvent = newestEvent;
        }
    }
}
