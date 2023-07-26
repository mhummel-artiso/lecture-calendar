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
