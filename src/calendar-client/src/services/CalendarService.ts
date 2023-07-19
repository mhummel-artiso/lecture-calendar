import axios, { AxiosError, AxiosResponse } from 'axios'
import { Calendar } from '../models/types'
import localforage from 'localforage'

export const CalendarService = () => {
    // TODO: Mus noch angepasst werden
    const getYear = async (
        calendarId: string,
        year: number
    ): Promise<Calendar | undefined> => {
        let calendar: Calendar

        await axios
            .get<Calendar, AxiosResponse<Calendar>>('data')
            .then(async ({ data }) => {
                calendar = data
                await localforage.setItem('calendar', JSON.stringify(data))
            })
            .catch(async (err: AxiosError) => {
                if (err.status === 404) {
                    throw Error('Kalender nicht vorhanden.')
                } else {
                    try {
                        calendar = (await localforage.getItem(
                            'calendar'
                        )) as Calendar
                    } catch (err) {
                        throw Error(
                            'LocalStorage beinhaltet nicht den Kalender oder in einer nicht richtigen Form.'
                        )
                    }
                }
            })

        return calendar
    }

    // TODO: Mus noch angepasst werden
    const getMonth = async (
        calendarId: string,
        year: number,
        month: number
    ): Promise<Calendar | undefined> => {
        let calendar: Calendar

        await axios
            .get<Calendar, AxiosResponse<Calendar>>('data')
            .then(async ({ data }) => {
                calendar = data
                await localforage.setItem('calendar', JSON.stringify(data))
            })
            .catch(async (err: AxiosError) => {
                if (err.status === 404) {
                    throw Error('Kalender nicht vorhanden.')
                } else {
                    try {
                        calendar = (await localforage.getItem(
                            'calendar'
                        )) as Calendar
                    } catch (err) {
                        throw Error(
                            'LocalStorage beinhaltet nicht den Kalender oder in einer nicht richtigen Form.'
                        )
                    }
                }
            })

        return calendar
    }
    return { getYear, getMonth }
}
