import {
    Paper,
    ToggleButton,
    ToggleButtonGroup,
    AppBar,
    Button,
    Grid,
    Toolbar,
    Typography,
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
import { useParams } from 'react-router-dom'

export const CalendarPage = () => {
    const [calendarView, setCalendarView] = useState('Week')

    const handleChange = (
        event: React.MouseEvent<HTMLElement>,
        newAlignment: string
    ) => {
        setCalendarView(newAlignment)
    }

    const currentDate = '2018-11-01T13:00'
    const schedulerData = [
        {
            startDate: '2018-11-01T09:45',
            endDate: '2018-11-01T11:00',
            title: 'Meeting',
        },
        {
            startDate: '2018-11-01T12:00',
            endDate: '2018-11-01T13:30',
            title: 'Go to a gym',
        },
    ]

    return (
        <Grid container>
            <NavBar />

            <Grid item>
                <Paper elevation={0}>
                    <Scheduler data={schedulerData} locale={'de-DE'}>
                        <ViewState
                            currentDate={currentDate}
                            currentViewName={calendarView}
                            defaultCurrentViewName={'Week'}
                        />
                        <DayView startDayHour={9} endDayHour={18} />

                        <WeekView startDayHour={9} endDayHour={18} />
                        <MonthView />

                        <Appointments />
                    </Scheduler>
                </Paper>
            </Grid>
        </Grid>
    )
}
