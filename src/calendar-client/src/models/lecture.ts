import { Moment } from "moment/moment"

export interface Lecture {
    id?: string
    title: string
    description?: string
    shortKey?: string
    createdDate?: Moment
    lastUpdateDate?: Moment
}
