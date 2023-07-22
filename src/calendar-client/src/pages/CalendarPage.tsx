import {
    Paper,
    ToggleButton,
    ToggleButtonGroup,
    AppBar,
    Button,
    Grid,
    Toolbar,
    Typography,
    Fab,
} from '@mui/material'
import React, { useState } from 'react'
import { ViewState } from '@devexpress/dx-react-scheduler'
import {
    Scheduler,
    DayView,
    WeekView,
    Appointments,
    MonthView,
} from '@devexpress/dx-react-scheduler-material-ui'
import { NavBar } from '../components/NavBar'

export const CalendarPage = () => {
    const [calendarView, setCalendarView] = useState('Week')
    const [currentDate, setCurrentDate] = useState(new Date())

    const handleChange = (
        event: React.MouseEvent<HTMLElement>,
        newAlignment: string
    ) => {
        setCalendarView(newAlignment)
    }

    const handleNavigate = (date: Date, isForward: boolean) => {
        const multiplier = isForward ? 1 : -1

        switch (calendarView) {
            case 'Day':
                date.setDate(date.getDate() + multiplier)
                break
            case 'Week':
                date.setDate(date.getDate() + multiplier * 7)
                break
            case 'Month':
                date.setMonth(date.getMonth() + multiplier)
                break
            default:
                break
        }

        setCurrentDate(new Date(date))
    }

    const formatCurrentDate = (viewType: string) => {
        switch (viewType) {
            case 'Day':
                return currentDate.toLocaleDateString('de-DE', {
                    weekday: 'long',
                    day: 'numeric',
                    month: 'long',
                    year: 'numeric',
                })
            case 'Week':
                const firstDayOfWeek = new Date(currentDate)
                const lastDayOfWeek = new Date(currentDate)
                const firstDay =
                    firstDayOfWeek.getDate() - firstDayOfWeek.getDay() + 1
                const lastDay = firstDay + 6
                firstDayOfWeek.setDate(firstDay)
                lastDayOfWeek.setDate(lastDay)
                return `${firstDayOfWeek.toLocaleDateString('de-DE', {
                    day: 'numeric',
                    month: 'long',
                })} - ${lastDayOfWeek.toLocaleDateString('de-DE', {
                    day: 'numeric',
                    month: 'long',
                    year: 'numeric',
                })}`
            case 'Month':
                return currentDate.toLocaleDateString('de-DE', {
                    month: 'long',
                    year: 'numeric',
                })
            default:
                return ''
        }
    }

    return (
        <Grid container>
            <NavBar />

            <Grid item>
                <Paper elevation={0}>
                    <Scheduler locale={'de-DE'} firstDayOfWeek={1}>
                        <ViewState
                            currentDate={currentDate}
                            currentViewName={calendarView}
                            defaultCurrentViewName={'Week'}
                        />
                        <DayView startDayHour={9} endDayHour={18} />
                        <WeekView startDayHour={9} endDayHour={18} />
                        <MonthView />

                        <Grid
                            container
                            justifyContent="space-between"
                            sx={{ padding: 3 }}
                        >
                            <Fab
                                color="primary"
                                onClick={() =>
                                    handleNavigate(currentDate, false)
                                }
                            >
                                &#10094;
                            </Fab>
                            <Typography variant="subtitle1">
                                {formatCurrentDate(calendarView)}
                            </Typography>
                            <Fab
                                color="primary"
                                onClick={() =>
                                    handleNavigate(currentDate, true)
                                }
                            >
                                &#10095;
                            </Fab>
                        </Grid>

                        <Appointments />
                    </Scheduler>
                </Paper>
            </Grid>
        </Grid>
    )
}
