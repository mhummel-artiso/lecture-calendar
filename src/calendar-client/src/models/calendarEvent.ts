import { Lecture } from './lecture'
import { Moment }from "moment/moment"

export interface CalendarEvent {
    id: string
    location: string
    description?: string
    start: Moment
    end: Moment
    endSeries?: string | undefined
    createdDate?: Moment
    lastUpdateDate?: Moment
    lecture: Lecture
    serieId: string
    rotation: number
    calendarId: string
}
export interface CreateCalendarEvent {
    location: string
    description?: string | undefined
    start: Moment
    end: Moment
    rotation: number
    endSeries?: Moment | undefined
    lectureId: string
    calendarId: string
}
