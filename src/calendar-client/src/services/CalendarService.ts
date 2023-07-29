import axios, { AxiosError, AxiosResponse } from 'axios'
import { Calendar } from '../models/calendar'
import localforage from 'localforage'
import { axiosInstance } from '../utils/axiosInstance'

// export const CalendarService = () => {
//     // // TODO: Mus noch angepasst werden
//     // const getYear = async (
//     //     calendarId: string,
//     //     year: number
//     // ): Promise<Calendar | undefined> => {
//     //     let calendar: Calendar
//     //
//     //     await axios
//     //         .get<Calendar, AxiosResponse<Calendar>>('data')
//     //         .then(async ({ data }) => {
//     //             calendar = data
//     //             await localforage.setItem('calendar', JSON.stringify(data))
//     //         })
//     //         .catch(async (err: AxiosError) => {
//     //             if (err.status === 404) {
//     //                 throw Error('Kalender nicht vorhanden.')
//     //             } else {
//     //                 try {
//     //                     calendar = (await localforage.getItem(
//     //                         'calendar'
//     //                     )) as Calendar
//     //                 } catch (err) {
//     //                     throw Error(
//     //                         'LocalStorage beinhaltet nicht den Kalender oder in einer nicht richtigen Form.'
//     //                     )
//     //                 }
//     //             }
//     //         })
//     //
//     //     return calendar
//     // }
//     //
//     // // TODO: Mus noch angepasst werden
//     // const getMonth = async (
//     //     calendarId: string,
//     //     year: number,
//     //     month: number
//     // ): Promise<Calendar | undefined> => {
//     //     let calendar: Calendar
//     //
//     //     await axios
//     //         .get<Calendar, AxiosResponse<Calendar>>('data')
//     //         .then(async ({ data }) => {
//     //             calendar = data
//     //             await localforage.setItem('calendar', JSON.stringify(data))
//     //         })
//     //         .catch(async (err: AxiosError) => {
//     //             if (err.status === 404) {
//     //                 throw Error('Kalender nicht vorhanden.')
//     //             } else {
//     //                 try {
//     //                     calendar = (await localforage.getItem(
//     //                         'calendar'
//     //                     )) as Calendar
//     //                 } catch (err) {
//     //                     throw Error(
//     //                         'LocalStorage beinhaltet nicht den Kalender oder in einer nicht richtigen Form.'
//     //                     )
//     //                 }
//     //             }
//     //         })
//     //
//     //     return calendar
//     // }
//
//
//
//
//
//     // return { getYear, getMonth, fetchCalendars }
//     return { fetchCalendars }
// }
export const fetchCalendars = async (): Promise<Calendar[]> => {
    const response = await axiosInstance.get<Calendar[]>('Calendar')
    return Promise.resolve(response.data)
}
