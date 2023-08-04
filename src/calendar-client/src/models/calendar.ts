import { CalendarEvent } from './calendarEvent'
import { Moment } from "moment/moment";

export interface Calendar {
    id?: string
    name: string
    startDate: Moment
    events?: CalendarEvent[]
    createdDate?: Moment
}
