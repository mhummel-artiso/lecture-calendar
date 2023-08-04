import { CalendarEvent } from './calendarEvent'
import { Dayjs } from "dayjs";

export interface Calendar {
    id?: string
    name: string
    startDate: Dayjs
    events?: CalendarEvent[]
    createdDate?: Dayjs
}
export interface CombinedCalendar extends Calendar{
    calendarIds: string[]
}
