import { Calendar } from '../models/calendar'
import { axiosInstance } from '../utils/axiosInstance'
import {
    CalendarEvent,
    CreateCalendarEvent,
    UpdateCalendarEvent,
    UpdateCalendarEventSeries,
} from '../models/calendarEvent'
import { AxiosError } from 'axios'

// Calendar functions
const calendarEndPointName = (calendarId: string | null = null) => {
    const path = 'Calendar'
    return calendarId ? path + `/${calendarId}` : path
}

export const addCalendar = async (calendar: Calendar): Promise<Calendar> => {
    const response = await axiosInstance.post<Calendar>(
        calendarEndPointName(),
        calendar
    )
    return Promise.resolve(response.data)
}

export const getCalendars = async (): Promise<Calendar[]> => {
    const response = await axiosInstance.get<Calendar[]>(calendarEndPointName())
    return Promise.resolve(response.data)
}
export const getAllCalendars = async (): Promise<Calendar[]> => {
    const response = await axiosInstance.get<Calendar[]>(
        `${calendarEndPointName()}/all`
    )
    return Promise.resolve(response.data)
}
export const getCalendar = async (calendarId: string): Promise<Calendar> => {
    const response = await axiosInstance.get<Calendar>(
        calendarEndPointName(calendarId)
    )
    return Promise.resolve(response.data)
}
export const getCalendarByName = async (
    calendarName: string
): Promise<Calendar> => {
    const path = calendarEndPointName()
    const response = await axiosInstance.get<Calendar>(
        `${path}/name/${calendarName}`
    )
    return Promise.resolve(response.data)
}

export const editCalendar = async (
    calendarId: string,
    calendar: Calendar
): Promise<Calendar> => {
    const response = await axiosInstance.put<Calendar>(
        calendarEndPointName(calendarId),
        calendar
    )
    return Promise.resolve(response.data)
}

export const deleteCalendar = async (calendarId: string): Promise<boolean> => {
    const response = await axiosInstance.delete<boolean>(
        calendarEndPointName(calendarId)
    )
    return Promise.resolve(response.data)
}

// Event calls
const eventEndPointName = (
    calendarId: string,
    eventId: string | null = null
) => {
    const path = `Calendar/${calendarId}/event`
    return eventId ? path + `/${eventId}` : path
}

export const addEvent = async (
    calendarId: string,
    event: CreateCalendarEvent
): Promise<CalendarEvent> => {
    const response = await axiosInstance.post<CalendarEvent>(
        eventEndPointName(calendarId),
        event
    )
    return Promise.resolve(response.data)
}

export const getEvents = async (
    calendarId: string
): Promise<CalendarEvent[]> => {
    const response = await axiosInstance.get<CalendarEvent[]>(
        eventEndPointName(calendarId)
    )
    return Promise.resolve(response.data)
}
export const getEventsFrom = async (
    calendarId: string,
    startDate: string,
    viewType: 'day' | 'week' | 'month'
): Promise<CalendarEvent[]> => {
    const basePath = eventEndPointName(calendarId)
    const response = await axiosInstance.get<CalendarEvent[]>(
        `${basePath}/${startDate}/${viewType}`
    )
    return Promise.resolve(response.data)
}
export const getEvent = async (calendarId: string, eventId: string) => {
    const response = await axiosInstance.get<CalendarEvent[]>(
        eventEndPointName(calendarId, eventId)
    )
    return Promise.resolve(response.data)
}

export const editEvent = async (
    calendarId: string,
    event: UpdateCalendarEvent
) => {
    const response = await axiosInstance.put<CalendarEvent>(
        eventEndPointName(calendarId, event.id),
        event
    )
    return Promise.resolve(response.data)
}

export const deleteEvent = async (calendarId: string, event: CalendarEvent) => {
    const response = await axiosInstance.delete<boolean>(
        eventEndPointName(calendarId, event.id)
    )
    return Promise.resolve(response.data)
}

const seriesEndPointName = (calendarId: string, seriesId: string) => {
    return `Calendar/${calendarId}/series/${seriesId}`
}

export const editEventSeries = async (
    calendarId: string,
    seriesId: string,
    event: UpdateCalendarEventSeries
) => {
    const response = await axiosInstance.put<CalendarEvent[]>(
        seriesEndPointName(calendarId, seriesId),
        event
    )
    return Promise.resolve(response.data)
}
export const deleteEventSeries = async (
    calendarId: string,
    seriesId: string
) => {
    const response = await axiosInstance.delete<boolean>(
        seriesEndPointName(calendarId, seriesId)
    )
    return Promise.resolve(response.data)
}
