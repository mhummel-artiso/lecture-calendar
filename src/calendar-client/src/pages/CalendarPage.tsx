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
    Stack,
    Box,
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
    const [calendarView, setCalendarView] = useState('Month')
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
        <Box sx={{ display: 'flex', height: '100%', flexDirection: 'column' }}>
            <NavBar />
            <Grid item container sx={{ padding: 3 }} alignItems="center">
                <Grid item xl={10} md={9} xs={12}>
                    <Grid
                        container
                        justifyContent="space-between"
                        alignItems="center"
                    >
                        <Fab
                            color="primary"
                            onClick={() => handleNavigate(currentDate, false)}
                        >
                            &#10094;
                        </Fab>
                        <Typography variant="subtitle1">
                            {formatCurrentDate(calendarView)}
                        </Typography>
                        <Fab
                            color="primary"
                            onClick={() => handleNavigate(currentDate, true)}
                        >
                            &#10095;
                        </Fab>
                    </Grid>
                </Grid>
                <Grid item xl={2} md={3} xs={12}>
                    <Grid
                        container
                        justifyContent="flex-end"
                        alignItems="center"
                    >
                        <ToggleButtonGroup
                            color="primary"
                            value={calendarView}
                            exclusive
                            onChange={handleChange}
                            aria-label="Platform"
                        >
                            <ToggleButton value="Month">Monat</ToggleButton>
                            <ToggleButton value="Week">Woche</ToggleButton>
                            <ToggleButton value="Day">Tag</ToggleButton>
                        </ToggleButtonGroup>
                    </Grid>
                </Grid>
            </Grid>
            <Grid sx={{ position: 'relative', flexGrow: 1 }}>
                <Grid
                    sx={{
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        position: 'absolute',
                    }}
                >
                    <Scheduler locale={'de-DE'} firstDayOfWeek={1}>
                        <ViewState
                            currentDate={currentDate}
                            currentViewName={calendarView}
                            defaultCurrentViewName={'Week'}
                        />
                        <DayView startDayHour={6} endDayHour={18} />
                        <WeekView startDayHour={6} endDayHour={18} />
                        <MonthView />

                        <Appointments />
                    </Scheduler>
                </Grid>
            </Grid>
        </Box>
    )
}
