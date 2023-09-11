import { Fab, Grid, Typography } from '@mui/material'
import AddIcon from '@mui/icons-material/Add'
import React, { useState } from 'react'
import { EditEventCallback, EventDialog } from '../eventDialog/EventDialog'
import { useAccount } from '../../hooks/useAccount'
import moment, { Moment } from 'moment'
import { useParams } from 'react-router'
import {
    addEvent,
    editEvent,
    editEventSeries,
} from '../../services/CalendarService'
import { useMutation } from '@tanstack/react-query'
import { queryClient } from '../../utils/queryClient'
import { CalendarEvent, CreateCalendarEvent } from '../../models/calendarEvent'
import { AxiosError } from 'axios'
import { CalendarDateNavigation } from './CalendarDateNavigation'
import { CalendarViewSwitch } from './CalendarViewSwitch'
import { CalendarScheduler } from './CalendarScheduler'
import { CalendarViewType } from '../../services/DateService'
import { AxiosErrorInformation } from '../ErrorContent/AxiosErrorInformation'

export const CalendarPage = () => {
    const { canEdit } = useAccount()
    const { calendarName } = useParams()
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
            await queryClient.invalidateQueries({
                queryKey: ['events', calendarName, calendarView],
            })
        },
    })

    // { mutate: mutateEdit, data: mutateEditResponse, error: mutateEditError, isError }
    const eventEditMutation = useMutation({
        mutationFn: async (e: EditEventCallback) => {
            if (e.event) {
                return await editEvent(e.calendarId, e.event)
            } else if (e.eventSeries) {
                return await editEventSeries(
                    e.calendarId,
                    e.eventSeries.seriesId,
                    e.eventSeries
                )
            }
        },
        onSuccess: async (_) => {
            await queryClient.invalidateQueries({
                queryKey: ['events', calendarName, calendarView],
            })
        },
        onError: async (error: AxiosError) => {
            if (error.status === 409) {
                await queryClient.invalidateQueries({
                    queryKey: ['events', calendarName, calendarView],
                })
            }
        },
    })

    return (
        <>
            <Grid item container sx={{ padding: 3 }} alignItems="center">
                <CalendarDateNavigation
                    currentDate={currentDate}
                    calendarView={calendarView}
                    onCurrentDateChanged={setCurrentDate}
                />
                <CalendarViewSwitch
                    value={calendarView}
                    onChange={setCalendarView}
                />
            </Grid>
            <Grid sx={{ position: 'relative', flexGrow: 1 }}>
                <CalendarScheduler
                    calendarId={claendarId}
                    onCalendarIdChanged={setCalendarId}
                    currentDate={currentDate}
                    onEventSelected={(event) => {
                        setIsEventDialogOpen(true)
                        setSelectedEvent(event)
                    }}
                    calendarView={calendarView}
                />
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
                    <AddIcon />
                </Fab>
            )}
            {isEventDialogOpen && canEdit && (
                <EventDialog
                    isDialogOpen={isEventDialogOpen}
                    onDialogClose={() => {
                        setIsEventDialogOpen(false)
                        setSelectedEvent(null)
                    }}
                    currentValue={selectedEvent}
                    calendarId={claendarId}
                    onDialogAdd={addEventMutation.mutate}
                    onDialogEdit={eventEditMutation.mutate}
                    onDeletedEvent={async (event: CalendarEvent) => {
                        await queryClient.invalidateQueries({
                            queryKey: [
                                'events',
                                calendarName,
                                calendarView,
                                currentDate,
                            ],
                        })
                    }}
                />
            )}
        </>
    )
}
