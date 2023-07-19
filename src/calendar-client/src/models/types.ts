export interface Lecture {
    Id?: string
    Title: string
    Comment?: string
    Professor?: string
    CreatedDate?: Date
    LastUpdateDate?: Date
}

export interface CalendarEvent {
    Id?: string
    Location: string
    Start: Date
    End: Date
    StartSeries?: Date
    EndSeries?: Date
    CreatedDate?: Date
    LastUpdateDate?: Date
    Lecture?: Lecture
}

export interface Calendar {
    Id?: string
    Name: string
    StartDate: Date
    Events?: CalendarEvent[]
    CreatedDate?: Date
}
