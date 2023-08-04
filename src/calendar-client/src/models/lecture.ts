import { Dayjs } from "dayjs";

export interface Lecture {
    id?: string
    title: string
    comment?: string
    professor?: string
    createdDate?: Dayjs
    lastUpdateDate?: Dayjs
}
