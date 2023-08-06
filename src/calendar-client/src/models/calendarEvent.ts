import { Lecture } from './lecture'
import { Moment } from "moment/moment"

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
}
export interface CreateCalendarEvent {
    location: string
    description?: string | undefined
    start: Moment
    end: Moment
    endSeries?: Moment | undefined
    lectureId: string
}