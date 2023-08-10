import {
    ToggleButton,
    ToggleButtonGroup,
    Grid,
    Typography,
    Fab,
} from '@mui/material'
import AddIcon from '@mui/icons-material/Add'
import KeyboardArrowRightIcon from '@mui/icons-material/KeyboardArrowRight'
import KeyboardArrowLeftIcon from '@mui/icons-material/KeyboardArrowLeft'
import React, { useEffect, useState } from 'react'
import { ViewState } from '@devexpress/dx-react-scheduler'
import {
    Scheduler,
    DayView,
    WeekView,
    Appointments,
    MonthView,
} from '@devexpress/dx-react-scheduler-material-ui'
import { EventDialog } from '../Calendar/EventDialog'
import { useAccount } from "../../hooks/useAccount";
import moment, { Moment } from "moment";
import { useLocation, useParams } from "react-router";
import { Calendar } from "../../models/calendar";
import { useNavigate } from "react-router-dom";

type CalendarViewType = 'month' | 'week' | 'day';

export const CalendarPage = () => {
    const {canEdit} = useAccount();
    const navigate = useNavigate()
    const {calendarName} = useParams();
    const location = useLocation()
    const [calendarView, setCalendarView] = useState<CalendarViewType>('week')
    const [currentDate, setCurrentDate] = useState<Moment>(moment())
    const [isDialogOpen, setIsDialogOpen] = useState(false)

    useEffect(() => {
        // TODO what should happen if the location.state is undefined?
        // This state is undefined if the user navigates direct without select a calendar in the nav bar to the given calendar,
        // for example the user paste the url .../calendar/123 direct into the browser and press enter.
        console.log('location', location.state, calendarName);
        const state = location.state as Calendar | Calendar[];

        if(calendarName && state) {
            const calendar = state as Calendar | undefined;
            // TODO load events for current events from location.state#
            console.log('load events for calendar: ', calendar);
        } else if(!calendarName && state) {
            const calendars = state as Calendar[]
            // TODO load all events for all calendar in state
            console.log('load events for calendars: ', calendars);
        }
    }, [calendarName, location.state])

    const handleChange = (
        event: React.MouseEvent<HTMLElement>,
        newAlignment: CalendarViewType | null
    ) => {
        if(newAlignment) {
            setCalendarView(newAlignment)
        }
    }

    const handleNavigate = (date: Moment, isForward: boolean) => {
        // adds or remove 1 day or week or month
        date.add(isForward ? 1 : -1, calendarView)
        setCurrentDate(moment(date));
    }

    const formatCurrentDate = (viewType: CalendarViewType) => {
        switch(viewType) {
            case 'day':
                return currentDate.format('dddd, DD.MMMM.YYYY');
            case 'week': {
                // calculate the first day of the week
                const firstDayOfWeek = moment(currentDate)
                    .add(-(currentDate.weekday()) + 1, "day")
                // calculate the last day of the week
                const lastDayOfWeek = moment(firstDayOfWeek)
                    .add(6, "day")
                return `${firstDayOfWeek.format('D.MM')} - ${lastDayOfWeek.format('D.MM.YYYY')}`
            }
            case 'month':
                return currentDate.format("MM.YYYY")
            default:
                return ''
        }
    }
    return (
        <>
            <Grid item container sx={{padding: 3}} alignItems="center">
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
                            <KeyboardArrowLeftIcon/>
                        </Fab>
                        <Typography variant="subtitle1">
                            {formatCurrentDate(calendarView)}
                        </Typography>
                        <Fab
                            color="primary"
                            onClick={() => handleNavigate(currentDate, true)}
                        >
                            <KeyboardArrowRightIcon/>
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
                            <ToggleButton value="month">Monat</ToggleButton>
                            <ToggleButton value="week">Woche</ToggleButton>
                            <ToggleButton value="day">Tag</ToggleButton>
                        </ToggleButtonGroup>
                    </Grid>
                </Grid>
            </Grid>
            <Grid sx={{position: 'relative', flexGrow: 1}}>
                <Grid
                    sx={{
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        position: 'absolute',
                    }}
                >
                    <Scheduler data={} locale={'de-DE'} firstDayOfWeek={1}>
                        <ViewState
                            currentDate={currentDate.toDate()}
                            currentViewName={calendarView}
                            defaultCurrentViewName={'month'}
                        />
                        <DayView name={"day"} startDayHour={6} endDayHour={18}/>
                        <WeekView name={"week"} startDayHour={6} endDayHour={18}/>
                        <MonthView name={"month"}/>
                        <Appointments/>
                    </Scheduler>
                </Grid>
            </Grid>
            {canEdit && (
                <Fab
                    color="primary"
                    sx={{
                        position: 'absolute',
                        bottom: 0,
                        right: 0,
                        margin: 7,
                    }}
                    onClick={() => setIsDialogOpen(true)}
                >
                    <AddIcon/>
                </Fab>
            )}
            <EventDialog
                isDialogOpen={isDialogOpen}
                onDialogClose={() => setIsDialogOpen(false)}
                calendarId={""}
                onDialogAdd={()=>{}}
                onDialogEdit={()=>{}}
            />
        </>
    )
}
