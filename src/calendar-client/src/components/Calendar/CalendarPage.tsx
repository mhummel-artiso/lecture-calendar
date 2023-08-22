import {
    Fab,
    Grid,
    ToggleButton,
    ToggleButtonGroup,
    Typography,
} from '@mui/material'
import AddIcon from '@mui/icons-material/Add'
import KeyboardArrowRightIcon from '@mui/icons-material/KeyboardArrowRight'
import KeyboardArrowLeftIcon from '@mui/icons-material/KeyboardArrowLeft'
import React, { useEffect, useState } from 'react'
import { AppointmentModel, ViewState } from '@devexpress/dx-react-scheduler'
import {
    Appointments,
    DayView,
    MonthView,
    Scheduler,
    WeekView,
} from '@devexpress/dx-react-scheduler-material-ui'
import { EditEventCallback, EventDialog } from '../eventDialog/EventDialog'
import { useAccount } from '../../hooks/useAccount'
import moment, { Moment } from 'moment'
import { useLocation, useParams } from 'react-router'
import { Calendar } from '../../models/calendar'
import { useNavigate } from 'react-router-dom'
import {
    addEvent,
    editEvent,
    editEventSeries,
    getCalendarByName,
    getEventsFrom,
} from '../../services/CalendarService'
import { useMutation, useQuery } from '@tanstack/react-query'
import { queryClient } from '../../utils/queryClient'
import { CalendarEvent, CreateCalendarEvent } from '../../models/calendarEvent'
import { CalendarDateNavigation } from "./CalendarDateNavigation";
import { CalendarViewSwitch } from "./CalendarViewSwitch";
import { CalendarScheduler } from "./CalendarScheduler";
import { CalendarViewType } from "../../services/dateService";

export const CalendarPage = () => {
    const {canEdit} = useAccount()
    const {calendarName} = useParams()
    const location = useLocation()
    const [calendarView, setCalendarView] = useState<CalendarViewType>('week')
    const [currentDate, setCurrentDate] = useState<Moment>(moment())
    const [isEventDialogOpen, setIsEventDialogOpen] = useState(false)
    const [selectedEvent, setSelectedEvent] = useState<CalendarEvent | null>(
        null
    )
    const [claendarId, setCalendarId] = useState<string>('')


    const addEventMutation = useMutation({
        mutationFn: async (event: CreateCalendarEvent) => {
            return await addEvent(event.calendarId, event)
        },
        onSuccess: async (_) => {
            await queryClient.invalidateQueries({queryKey: ['events', calendarName, calendarView]})
        },
    })
    const eventEditMutation = useMutation({
        mutationFn: async (e: EditEventCallback) => {
            if(e.event) {
                return await editEvent(e.calendarId, e.event)
            } else if(e.eventSeries) {
                return await editEventSeries(
                    e.calendarId,
                    e.eventSeries.seriesId,
                    e.eventSeries
                )
            }
        },
    })

    return (
        <>
            <Grid item container sx={{padding: 3}} alignItems="center">
                <CalendarDateNavigation currentDate={currentDate}
                                        calendarView={calendarView}
                                        onCurrentDateChanged={setCurrentDate}/>
                <CalendarViewSwitch value={calendarView} onChange={setCalendarView}/>
            </Grid>
            <Grid sx={{position: 'relative', flexGrow: 1}}>
                <CalendarScheduler
                    calendarId={claendarId}
                    onCalendarIdChanged={setCalendarId}
                    currentDate={currentDate}
                    onEventSelected={(event) => {
                        setIsEventDialogOpen(true)
                        setSelectedEvent(event)
                    }} calendarView={calendarView}/>
            </Grid>
            {
                canEdit && (
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
                )
            }
            {
                isEventDialogOpen && canEdit && (
                    <EventDialog
                        isDialogOpen={isEventDialogOpen}
                        onDialogClose={() => {
                            setIsEventDialogOpen(false)
                            setSelectedEvent(null)
                        }}
                        currentValue={selectedEvent}
                        calendarId={claendarId}
                        onDialogAdd={addEventMutation.mutate}
                        // TODO: Edit to be able to edit Event
                        onDialogEdit={eventEditMutation.mutate}
                        onDeletedEvent={async (event: CalendarEvent) => {
                            await queryClient.invalidateQueries({
                                queryKey: ['events', calendarName, calendarView]
                            })
                        }}
                    />
                )
            }
        </>
    )
}
