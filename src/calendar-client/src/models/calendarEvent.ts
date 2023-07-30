import { Lecture } from './lecture'

export interface CalendarEvent {
    id: string
    location: string
    description?: string
    start: string
    end: string
    endSeries?: string | undefined
    createdDate?: string
    lastUpdateDate?: string
    lecture: Lecture
}
export interface CreateCalendarEvent {
    location: string
    description?: string | undefined
    start: string
    end: string
    endSeries?: string | undefined
    lectureId: string
}
