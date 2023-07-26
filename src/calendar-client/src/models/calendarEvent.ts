import { Lecture } from './lecture'

export interface CalendarEvent {
    id?: string
    location: string
    start: Date
    end: Date
    startSeries?: Date
    endSeries?: Date
    createdDate?: Date
    lastUpdateDate?: Date
    lecture?: Lecture
}
