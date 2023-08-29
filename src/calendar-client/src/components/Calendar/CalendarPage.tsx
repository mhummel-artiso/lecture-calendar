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
import { ConflictDialog } from '../conflictDialog/ConflictDialog'
import { AxiosError } from 'axios'

type CalendarViewType = 'month' | 'week' | 'day'

export const CalendarPage = () => {
    const { canEdit } = useAccount()
    const navigate = useNavigate()
    const { calendarName } = useParams()
    const location = useLocation()
    const [calendarView, setCalendarView] = useState<CalendarViewType>('week')
    const [currentDate, setCurrentDate] = useState<Moment>(moment())
    const [isEventDialogOpen, setIsEventDialogOpen] = useState(false)
    const [selectedEvent, setSelectedEvent] = useState<CalendarEvent | null>(
        null
    )
    const [claendarId, setCalendarId] = useState<string>('')
    const getEvents = async () => {
        const state = location.state as Calendar[] | undefined | null

        if (state) {
            const calendar = state

            const startDate = getStartDateFromCurrentDate()
            const events: CalendarEvent[] = []
            if (calendar.length === 1) {
                setCalendarId(calendar[0].id!)
            }
            for (const c of calendar) {
                const result = await getEventsFrom(
                    c?.id!,
                    startDate,
                    calendarView
                )
                events.push(...result)
            }
            return events
        } else if (calendarName) {
            try {
                const c = await getCalendarByName(calendarName)
                setCalendarId(c.id!)
                navigate(`/calendar/${calendarName}`, { state: [c] })
            } catch (error) {
                navigate(`*`)
            }
        } else {
            navigate(`/`)
        }
        return []
    }

    const { data: events, refetch } = useQuery({
        queryKey: ['events', calendarName, calendarView],
        queryFn: getEvents,
        useErrorBoundary: true,
    })

    // Invalidates events when parameters change
    useEffect(() => {
        queryClient.invalidateQueries({ queryKey: ['events'] })
    }, [calendarName, location.state, calendarView, currentDate])

    const appointments = events?.map((c) => {
        const a: AppointmentModel = {
            startDate: moment(c.start).toDate(),
            endDate: moment(c.end).toDate(),
            title: c.lecture.title,
            location: c.location,
            event: c,
        }
        if (c.repeat > 0) {
            switch (c.repeat) {
                case 1:
                    a.rRule = 'FREQ=DAILY;COUNT=1'
                    break
                case 2:
                    a.rRule = 'FREQ=WEEKLY;COUNT=1'
                    break
                case 3:
                    a.rRule = 'FREQ=MONTHLY;COUNT=1'
            }
        }
        return a
    })

    const getStartDateFromCurrentDate = (): string => {
        switch (calendarView) {
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

    const handleViewChange = (
        event: React.MouseEvent<HTMLElement>,
        newAlignment: CalendarViewType | null
    ) => {
        if (newAlignment) {
            setCalendarView(newAlignment)
        }
    }

    const handleDataNavigation = (date: Moment, isForward: boolean) => {
        // adds or remove 1 day or week or month
        date.add(isForward ? 1 : -1, calendarView)
        setCurrentDate(moment(date))
    }

    const formatCurrentDateView = () => {
        switch (calendarView) {
            case 'day':
                return currentDate.format('dddd, DD. MMMM YYYY')
            case 'week': {
                const firstDayOfWeek = currentDate.clone().weekday(1)
                const lastDayOfWeek = currentDate.clone().weekday(7)
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

    // Custom Appointments Component
    const CustomAppointment: React.FC<Appointments.AppointmentProps> = ({
        onClick,
        children,
        ...restProps
    }) => {
        return (
            <Appointments.Appointment
                {...restProps}
                onClick={(e) => {
                    const {
                        data: { event },
                    } = e
                    if (!event) {
                        return
                    }
                    setIsEventDialogOpen(true)
                    setSelectedEvent(event as CalendarEvent)
                    if (onClick) {
                        onClick(e)
                    }
                }}
            >
                {children}
            </Appointments.Appointment>
        )
    }

    const addEventMutation = useMutation({
        mutationFn: async (event: CreateCalendarEvent) => {
            return await addEvent(event.calendarId, event)
        },
        onSuccess: async (_) => {
            await refetch()
        },
    })

    // { mutate: mutateEdit, data: mutateEditResponse, error: mutateEditError, isError }
    const eventEditMutation = useMutation({
        mutationFn: async (e: EditEventCallback) => {
            console.log('mutate', e)
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
            await refetch()
        },
    })

    // useEffect(() => {
    //     console.log("error", mutateEditError);
    //     console.log("response", mutateEditResponse)
    // }, [mutateEditResponse, mutateEditError])

    return (
        <>
            <Grid item container sx={{ padding: 3 }} alignItems="center">
                <Grid item xl={10} md={9} xs={12}>
                    <Grid
                        container
                        justifyContent="space-between"
                        alignItems="center"
                    >
                        <Fab
                            color="primary"
                            onClick={() =>
                                handleDataNavigation(currentDate, false)
                            }
                        >
                            <KeyboardArrowLeftIcon />
                        </Fab>
                        <Typography variant="subtitle1">
                            {formatCurrentDateView()}
                        </Typography>
                        <Fab
                            color="primary"
                            onClick={() =>
                                handleDataNavigation(currentDate, true)
                            }
                        >
                            <KeyboardArrowRightIcon />
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
                    <Scheduler
                        data={appointments}
                        locale={'de-DE'}
                        firstDayOfWeek={1}
                    >
                        <ViewState
                            currentDate={currentDate.toDate()}
                            currentViewName={calendarView}
                            defaultCurrentViewName={'month'}
                        />
                        <DayView
                            name={'day'}
                            startDayHour={7}
                            endDayHour={17}
                        />
                        <WeekView
                            name={'week'}
                            startDayHour={7}
                            endDayHour={17}
                        />
                        <MonthView name={'month'} />
                        <Appointments
                            appointmentComponent={CustomAppointment}
                        />
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
                    <AddIcon />
                </Fab>
            )}

            {isEventDialogOpen && (
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
                            queryKey: ['events'],
                        })
                    }}
                />
            )}

            <ConflictDialog
                title={'Datenkonflikt'}
                error={eventEditMutation.error as AxiosError}
                conflictStatus={409}
            >
                <Typography>
                    Ihre Änderungen konnten nicht gespeichert werden, da Sie
                    sonst neue Änderungen von einem Kollegen überschreiben
                    würden. Bitte schließen Sie den Dialog, und schauen Sie sich
                    die neuen Änderungen an und probieren Sie es gegebenenfalls
                    erneut.
                </Typography>
            </ConflictDialog>
        </>
    )
}
