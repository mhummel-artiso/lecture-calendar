import { CalendarEvent } from './calendarEvent'

export interface Calendar {
    Id?: string
    Name: string
    StartDate: Date
    Events?: CalendarEvent[]
    CreatedDate?: Date
}
