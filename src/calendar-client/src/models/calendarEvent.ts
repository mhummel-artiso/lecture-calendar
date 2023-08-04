import { Lecture } from './lecture'
import { Dayjs } from "dayjs";

export interface CalendarEvent {
    id: string
    location: string
    description?: string
    start: Dayjs
    end: Dayjs
    endSeries?: string | undefined
    createdDate?: Dayjs
    lastUpdateDate?: Dayjs
    lecture: Lecture
}
export interface CreateCalendarEvent {
    location: string
    description?: string | undefined
    start: Dayjs
    end: Dayjs
    endSeries?: Dayjs | undefined
    lectureId: string
}
