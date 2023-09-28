import { Moment } from 'moment/moment'

export type CalendarViewType = 'month' | 'week' | 'day'

export const getStartDateFromCurrentDate = (
    currentDate: Moment,
    calendarView: CalendarViewType
): string => {
    switch (calendarView) {
        case 'day':
            // Current Day
            return currentDate.clone().format('')
        case 'week': {
            // First Day of Week
            return currentDate.clone().weekday(0).format('')
        }
        case 'month':
            // First Day of Month
            return currentDate.clone().startOf('month').format('')
        default:
            return 'Invalid View Type'
    }
}

export const formatCurrentDateView = (
    currentDate: Moment,
    calendarView: CalendarViewType
) => {
    switch (calendarView) {
        case 'day':
            return currentDate.format('dddd, DD. MMMM YYYY')
        case 'week': {
            const firstDayOfWeek = currentDate.clone().startOf('week')
            const lastDayOfWeek = currentDate.clone().weekday(6)
            return `${firstDayOfWeek.format('DD.MM')} - ${lastDayOfWeek.format(
                'DD.MM.YYYY'
            )}`
        }
        case 'month':
            return currentDate.format('MM.YYYY')
        default:
            return 'Invalid View Type'
    }
}
