import { Moment } from "moment/moment";

export type CalendarViewType = 'month' | 'week' | 'day'
export const getStartDateFromCurrentDate = (currentDate: Moment, calendarView: CalendarViewType): string => {
    switch(calendarView) {
        case 'day':
            // Current Day
            return currentDate.clone().format('YYYY-MM-DD')
        case 'week': {
            // First Day of Week
            return currentDate.clone().weekday(1).format('YYYY-MM-DD')
        }
        case 'month':
            // First Day of Month
            return currentDate.clone().startOf('month').format('YYYY-MM-DD')
        default:
            return 'Invalid View Type'
    }
}

export const formatCurrentDateView = (currentDate: Moment, calendarView: CalendarViewType) => {
    switch(calendarView) {
        case 'day':
            return currentDate.format('dddd, DD. MMMM YYYY')
        case 'week': {
            const firstDayOfWeek = currentDate.clone().startOf("week")//.weekday(1)
            const lastDayOfWeek = currentDate.clone().weekday(6)
            return `${firstDayOfWeek.format(
                'D.MM'
            )} - ${lastDayOfWeek.format('D.MM.YYYY')}`
        }
        case 'month':
            return currentDate.format('MM.YYYY')
        default:
            return 'Invalid View Type'
    }
}