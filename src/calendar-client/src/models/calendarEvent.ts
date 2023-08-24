import { Calendar } from './calendar'
import { Lecture } from './lecture'
import { Moment } from 'moment/moment'
import { Instructor } from './instructor'

export interface CalendarEventBase {
    location: string
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
    startSeries?: Moment
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
    instructors: Instructor[]
}

export interface UpdateCalendarEventSeries extends CalendarEventBase {
    calendarId: string
    seriesId: string
    endSeries: Moment
    lectureId: string
    lastUpdateDate?: Moment
    createdDate?: Moment
}
