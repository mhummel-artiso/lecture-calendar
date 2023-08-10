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
import { AppointmentModel, ViewState } from '@devexpress/dx-react-scheduler'
import {
    Scheduler,
    DayView,
    WeekView,
    Appointments,
    AppointmentTooltip,
    MonthView,
} from '@devexpress/dx-react-scheduler-material-ui'
import { EventDialog } from '../Calendar/EventDialog'
import { useAccount } from "../../hooks/useAccount";
import moment, { Moment } from "moment";
import { useLocation, useParams } from "react-router";
import {  Calendar} from "../../models/calendar";
import { useNavigate } from "react-router-dom";
import { getCalendarByName, getEventsFrom } from '../../services/CalendarService'
import { useMutation, useQuery } from '@tanstack/react-query'
import { queryClient } from '../../utils/queryClient'
import { CreateCalendarEvent, CalendarEvent } from '../../models/calendarEvent'
import {addEvent} from "../../services/CalendarService"

type CalendarViewType = 'month' | 'week' | 'day';

export const CalendarPage = () => {
    const {canEdit} = useAccount();
    const navigate = useNavigate()
    const {calendarName} = useParams();
    const location = useLocation()
    const [calendarView, setCalendarView] = useState<CalendarViewType>('week')
    const [currentDate, setCurrentDate] = useState<Moment>(moment())
    const [isEventDialogOpen, setIsEventDialogOpen] = useState(false)
    const [selectedEvent, setSelectedEvent] = useState<CalendarEvent | null>(null)
    const [claendarId,setCalendarId] = useState<string>("")
    const getEvents = async () => {
        const state = location.state as Calendar[] | undefined | null;

        if(state) {
            const calendar = state as Calendar[];
            
            const startDate = getStartDateFromCurrentDate();
            const events: CalendarEvent[] = [];
            if(calendar.length===1)
                setCalendarId(calendar[0].id!)
            for (const c of calendar){
                const result = await getEventsFrom(c?.id!, startDate, calendarView!);
                console.log(result)
                events.push(...result);
            }
            return events;
        }
        else if(calendarName){
            try{
                const c = await getCalendarByName(calendarName);
                setCalendarId(c.id!)
                navigate(`/calendar/${calendarName}`, { state: [c] });
            }
            catch(error){
                navigate(`*`);
            }
        }
        else{
            navigate(`/`);
        }
        return [];
    }

    const {data: events,refetch} = useQuery({
        queryKey: ['events', calendarName, calendarView],
        queryFn: getEvents,
        useErrorBoundary: true,
    })

    // Invalidates events when parameters change
    useEffect(() => {
       queryClient.invalidateQueries({queryKey: ['events']})
    }, [calendarName, location.state, calendarView, currentDate])

    const appointments = events?.map(c => {
        return {
            startDate: moment(c.start), 
            endDate: moment(c.end), 
            title: c.lecture.title,
            location: c.location,
            event: c
        } as unknown as AppointmentModel}
    );

    const getStartDateFromCurrentDate = (): string =>{
        switch(calendarView){
            case 'day':
                // Current Day
                return currentDate.clone().format('YYYY-MM-DD');
            case 'week': {
                // First Day of Week
                return currentDate.clone().weekday(1).format('YYYY-MM-DD');
            }
            case 'month':
                // First Day of Month
                return currentDate.clone().startOf('month').format('YYYY-MM-DD');
            default:
                return 'Invalid View Type';
        }
    }

    const handleViewChange = (
        event: React.MouseEvent<HTMLElement>,
        newAlignment: CalendarViewType | null
    ) => {
        if(newAlignment) {
            setCalendarView(newAlignment)
        }
    }

    const handleDataNavigation = (date: Moment, isForward: boolean) => {
        // adds or remove 1 day or week or month
        date.add(isForward ? 1 : -1, calendarView)
        setCurrentDate(moment(date));
    }

    const formatCurrentDateView = () => {
        switch(calendarView) {
            case 'day':
                return currentDate.format('dddd, DD. MMMM YYYY');
            case 'week': {
                const firstDayOfWeek =  currentDate.clone().weekday(1);
                const lastDayOfWeek = currentDate.clone().weekday(7);
                
                return `${firstDayOfWeek.format('D.MM')} - ${lastDayOfWeek.format('D.MM.YYYY')}`
            }
            case 'month':
                return currentDate.format("MM.YYYY")
            default:
                return 'Invalid View Type'
        }
    }

    // Custom Appointments Component
    const CustomAppointment: React.FC<Appointments.AppointmentProps> = ({ onClick, children, ...restProps}) => {
        return(
                <Appointments.Appointment {...restProps} onClick={(e) => {
                    setIsEventDialogOpen(true);
                    setSelectedEvent(e.data.event as CalendarEvent)
                    if(onClick)
                    onClick(e)
                }}>
                {children}
                </Appointments.Appointment>
        );
    };
    const addEventMutation=useMutation({
        mutationFn: async (event:CreateCalendarEvent) => {
            addEvent(event.calendarId, event)
        },
        onSuccess: async (_) => {
            await refetch()
        },

    })
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
                            onClick={() => handleDataNavigation(currentDate, false)}
                        >
                            <KeyboardArrowLeftIcon/>
                        </Fab>
                        <Typography variant="subtitle1">
                            {formatCurrentDateView()}
                        </Typography>
                        <Fab
                            color="primary"
                            onClick={() => handleDataNavigation(currentDate, true)}
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
                            onChange={handleViewChange}
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
                    <Scheduler data={appointments} locale={'de-DE'} firstDayOfWeek={1}>
                        <ViewState
                            currentDate={currentDate.toDate()}
                            currentViewName={calendarView}
                            defaultCurrentViewName={'month'}
                        />
                        <DayView name={"day"} startDayHour={7} endDayHour={17}/>
                        <WeekView name={"week"} startDayHour={7} endDayHour={17}/>
                        <MonthView name={"month"}/>
                        <Appointments appointmentComponent={CustomAppointment}/>
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
                    onClick={() => setIsEventDialogOpen(true)}
                >
                    <AddIcon/>
                </Fab>
            )}

            {isEventDialogOpen && <EventDialog
                isDialogOpen={isEventDialogOpen}
                onDialogClose={() => {
                    setIsEventDialogOpen(false)
                    setSelectedEvent(null)
                } }
                currentValue={selectedEvent}
                calendarId={claendarId}
                onDialogAdd={(event) => {

                    addEventMutation.mutate(event) 
                } }
                // TODO: Edit to be able to edit Event
                onDialogEdit={() => { } } 
                onDeletedEvent={(event: CalendarEvent) => {
                    queryClient.invalidateQueries({queryKey: ['events']});
                } }/>}
        </>
    )
}
