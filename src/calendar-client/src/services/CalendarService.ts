import { Calendar } from '../models/calendar'
import { axiosInstance } from '../utils/axiosInstance'
import { CalendarEvent, CreateCalendarEvent } from "../models/calendarEvent";
import { Moment } from "moment/moment"

// calendar functions
const calendarEndPointName = (calendarId: string | null = null) => {
    const path = 'Calendar';
    return calendarId ? path + `/${calendarId}` : path;
};

export const addCalendar = async (calendar: Calendar): Promise<Calendar> => {
    const response = await axiosInstance.post<Calendar>(calendarEndPointName(), calendar)
    return Promise.resolve(response.data);
}

export const getCalendars = async (): Promise<Calendar[]> => {
    const response = await axiosInstance.get<Calendar[]>(calendarEndPointName())
    return Promise.resolve(response.data)
}
export const getCalendar = async (calendarId: string): Promise<Calendar> => {
    const response = await axiosInstance.get<Calendar>(calendarEndPointName(calendarId))
    return Promise.resolve(response.data)
}
export const editCalendar = async (calendarId: string, calendar: Calendar): Promise<Calendar> => {
    console.log(calendarId, calendar);
    const response = await axiosInstance.put<Calendar>(calendarEndPointName(calendarId), calendar);
    return Promise.resolve(response.data)
}

export const deleteCalendar = async (calendarId: string): Promise<boolean> => {
    const response = await axiosInstance.delete<boolean>(calendarEndPointName(calendarId));
    return Promise.resolve(response.data);
}

// event calls
const eventEndPointName = (calendarId: string, eventId: string | null = null) => {
    const path = `Calendar/${calendarId}/event`;
    return eventId ? path + `/${eventId}` : path;
};

export const addEvent = async (calendarId: string, event: CreateCalendarEvent): Promise<CalendarEvent> => {
    const response = await axiosInstance.post<CalendarEvent>(eventEndPointName(calendarId), event)
    return Promise.resolve(response.data)
}

export const getEvents = async (calendarId: string): Promise<CalendarEvent[]> => {
    const response = await axiosInstance.get<CalendarEvent[]>(eventEndPointName(calendarId));
    return Promise.resolve(response.data);
}
export const getEventsFrom = async (calendarId: string, startDate: string, viewType: 'day' | 'week' | 'month'): Promise<CalendarEvent[]> => {
    const basePath = eventEndPointName(calendarId);
    const response = await axiosInstance.get<CalendarEvent[]>(`${basePath}/${startDate}/${viewType}`);
    return Promise.resolve(response.data);
}
export const getEvent = async (calendarId: string, eventId: string) => {
    const response = await axiosInstance.get<CalendarEvent[]>(eventEndPointName(calendarId, eventId));
    return Promise.resolve(response.data);
}

export const editEvent = async (calendarId: string, event: CalendarEvent) => {
    const response = await axiosInstance.put<CalendarEvent>(eventEndPointName(calendarId, event.id), event);
    return Promise.resolve(response.data);
}

export const deleteEvent = async (calendarId: string, event: CalendarEvent) => {
    const response = await axiosInstance.delete<boolean>(eventEndPointName(calendarId, event.id));
    return Promise.resolve(response.data);
}
export const deleteEventSeries = async (calendarId: string, eventSerieId: string) => {
    const path = eventEndPointName(calendarId);
    const response = await axiosInstance.delete<boolean>(`${path}/serie/${eventSerieId}`);
    return Promise.resolve(response.data)
}