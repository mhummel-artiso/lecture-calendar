import { CalendarEvent } from './calendarEvent'
import { Moment } from "moment/moment";

export interface Calendar {
    id?: string
    name: string
    startDate: Moment
    events?: CalendarEvent[]
    lastUpdateDate?: Moment
    createdDate?: Moment
}

export interface KeycloakCalendar {
    keycloakGroupId: string
    name: string
}
