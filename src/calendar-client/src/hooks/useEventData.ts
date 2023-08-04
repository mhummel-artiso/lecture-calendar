import { useMutation } from '@tanstack/react-query'
import { axiosInstance } from '../utils/axiosInstance'
import { CalendarEvent, CreateCalendarEvent } from '../models/calendarEvent'
import { AxiosError } from 'axios'

export interface AddEventType {
    event: CreateCalendarEvent
    calendarId: string
}

export const addEvent = async ({
    event,
    calendarId,
}: AddEventType): Promise<CalendarEvent> => {
    const response = await axiosInstance.post<CalendarEvent>(
        `Calendar/${calendarId}/event`,
        event
    )
    return Promise.resolve(response.data)
}

export const useAddEvent = () => {
    return useMutation<CalendarEvent, AxiosError, AddEventType>((v) =>
        addEvent(v)
    )
}
