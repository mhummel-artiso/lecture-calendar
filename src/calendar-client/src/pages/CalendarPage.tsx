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


const styles = {
    buttonright: {
      position: 'fixed',
      bottom: '50%',
      right: '20px',
    },
    buttonleft: {
        position: 'fixed',
        bottom: '50%',
        left: '100px',
      },
};



export const CalendarPage = () => {
    const [calendarView, setCalendarView] = useState('Week');
    const [currentDate, setCurrentDate] = useState(new Date());

    const handleChange = (
        event: React.MouseEvent<HTMLElement>,
        newAlignment: string
    ) => {
        setCalendarView(newAlignment)
    }

    const handleNavigate = (date: Date, isForward: boolean) => {
        const multiplier = isForward ? 1 : -1;
    
        switch (calendarView) {
            case 'Day':
                date.setDate(date.getDate() + multiplier);
                break;
            case 'Week':
                date.setDate(date.getDate() + multiplier * 7);
                break;
            case 'Month':
                date.setMonth(date.getMonth() + multiplier);
                break;
            default:
                break;
        }

        setCurrentDate(new Date(date)); 
    };

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
            <AppBar position="sticky">
                <Toolbar>
                    <Grid container alignItems="center">
                        <Grid item container md={3}>
                            <Typography variant="h6">
                                Studienkalender
                            </Typography>
                        </Grid>
                        <Grid item container justifyContent="flex-end" md={8}>
                            <Paper>
                                <ToggleButtonGroup
                                    size="small"
                                    color="standard"
                                    value={calendarView}
                                    exclusive
                                    onChange={handleChange}
                                >
                                    <ToggleButton value="Day">Tag</ToggleButton>

                                    <ToggleButton value="Week">
                                        Woche
                                    </ToggleButton>
                                    <ToggleButton value="Month">
                                        Monat
                                    </ToggleButton>
                                </ToggleButtonGroup>
                            </Paper>
                        </Grid>
                        <Grid item container justifyContent="flex-end" md={1}>
                            <Button color="inherit">Abmelden</Button>
                        </Grid>
                    </Grid>
                </Toolbar>
            </AppBar>

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

                        <Grid container justifyContent="space-between" sx={{padding: 3}}>
                            <Fab color="primary" onClick={() => handleNavigate(currentDate, false)}>&#10094;</Fab>
                            <Fab color="primary" onClick={() => handleNavigate(currentDate, true)}>&#10095;</Fab>
                        </Grid>

                        <Appointments />
                    </Scheduler>
                </Paper>
            </Grid>
        </Grid>
    )
}
