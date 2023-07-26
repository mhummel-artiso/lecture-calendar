import { CalendarEvent } from './calendarEvent'

export interface Calendar {
    id?: string
    name: string
    startDate: Date
    events?: CalendarEvent[]
    createdDate?: Date
}
