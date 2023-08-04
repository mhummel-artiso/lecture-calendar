import axios, { AxiosError, AxiosResponse } from 'axios'
import { Calendar } from '../models/calendar'
import localforage from 'localforage'
import { axiosInstance } from '../utils/axiosInstance'

// export const CalendarService = () => {
// TODO: write in English !!
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
// TODO: write in English !!
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
const endPointName = 'Calendar';
export const addCalendar = async (calendar: Calendar): Promise<Calendar> => {
    const response = await axiosInstance.post<Calendar>(endPointName, calendar)
    return Promise.resolve(response.data);
}
export const fetchCalendars = async (): Promise<Calendar[]> => {
    const response = await axiosInstance.get<Calendar[]>(endPointName)
    return Promise.resolve(response.data)
}
export const editCalendar = async (calendarId: string, calendar: Calendar): Promise<Calendar> => {
    const response = await axiosInstance.put<Calendar>(`${endPointName}/${calendarId}`, calendar);
    return Promise.resolve(response.data)
}
export const deleteCalendar = async (calendarId: string): Promise<boolean> => {
    const response = await axiosInstance.delete<boolean>(`${endPointName}/${calendarId}`);
    return Promise.resolve(response.data);
}