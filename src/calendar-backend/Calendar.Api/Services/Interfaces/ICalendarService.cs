using Calendar.Api.Models;
using Calendar.Mongo.Db.Models;
namespace Calendar.Api.Services.Interfaces;

public interface ICalendarService
{
    Task<UserCalendar> GetCalendarByIdAsync(string id, ViewType viewType);
    Task<UserCalendar> GetCalendarByNameAsync(string name);

    Task<UserCalendar> AddCalendarAsync(UserCalendar calendar);

    Task<UserCalendar> UpdateCalendarAsync(string id, UserCalendar calendar);

    Task <bool>DeleteCalendarByIdAsync(string id);

}