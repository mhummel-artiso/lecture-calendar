import { Calendar } from './calendar'
import { Instructor } from './instructor'
import { Lecture } from './lecture'
import { Moment } from "moment/moment"

interface CalendarEventBase {
    location: string,
    description?: string
    start: Moment
    end: Moment
    instructors: Instructor[]
    repeat: number
    calendarId: string
}

export interface CalendarEvent extends CalendarEventBase {
    id: string
    endSeries?: string | undefined
    createdDate?: Moment
    lastUpdateDate?: Moment
    calendar: Calendar
    lecture: Lecture
    seriesId: string
}

export interface CreateCalendarEvent extends CalendarEventBase {
    endSeries?: Moment | undefined
    lectureId: string
    calendarId: string
}

export interface UpdateCalendarEvent extends CalendarEventBase {
    id?: string
    calendarId: string
    seriesId?: string
    lectureId: string
    endSeries: Moment
    // this dates only necessary for api to check the last edit
    lastUpdateDate?: Moment
    createdDate?: Moment
}

export interface UpdateCalendarEventSeries extends CalendarEventBase {
    calendarId: string
    seriesId: string
    endSeries: Moment
    lectureId: string
    lastUpdateDate?: Moment
    createdDate?: Moment
}