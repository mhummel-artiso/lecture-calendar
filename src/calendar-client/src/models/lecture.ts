import { Moment } from "moment/moment"

export interface Lecture {
    id?: string
    title: string
    comment?: string
    professor?: string
    createdDate?: Moment
    lastUpdateDate?: Moment
}
