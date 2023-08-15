import { useMutation } from '@tanstack/react-query'
import { axiosInstance } from '../utils/axiosInstance'
import { CalendarEvent, CreateCalendarEvent } from '../models/calendarEvent'
import { AxiosError } from 'axios'
import { addEvent } from '../services/CalendarService'

export interface AddEventType {
    event: CreateCalendarEvent
    calendarId: string
}

export const useAddEvent = () => {
    return useMutation<CalendarEvent, AxiosError, AddEventType>((v) =>
        addEvent(v.calendarId, v.event)
    )
}
