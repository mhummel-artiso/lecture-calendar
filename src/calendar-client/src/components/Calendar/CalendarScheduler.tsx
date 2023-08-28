import {
    Appointments,
    AppointmentTooltip,
    DayView,
    MonthView,
    Scheduler,
    WeekView
} from "@devexpress/dx-react-scheduler-material-ui";
import { AppointmentModel, ViewState } from "@devexpress/dx-react-scheduler";
import { Grid, Typography } from "@mui/material";
import React, { useEffect } from "react";
import moment, { Moment } from "moment/moment";
import { useQuery } from "@tanstack/react-query";
import { getCalendarByName, getEventsFrom } from "../../services/CalendarService";
import { CalendarEvent } from "../../models/calendarEvent";
import { Calendar } from "../../models/calendar";
import { CalendarViewType, getStartDateFromCurrentDate } from "../../services/DateService";
import { useLocation, useParams } from "react-router";
import { useNavigate } from "react-router-dom";
import { queryClient } from "../../utils/queryClient";
import { useAccount } from "../../hooks/useAccount";
import { AppointmentTooltipContent, AppointmentTooltipHeader } from "./AppointmentTooltip";

interface Props {
    currentDate: Moment
    calendarView: CalendarViewType
    onEventSelected: (event: CalendarEvent) => void
    startDayHour?: number
    endDayHour?: number
    calendarId: string
    onCalendarIdChanged: (id: string) => void
}

export const CalendarScheduler: React.FC<Props> = (porps) => {
    const {
        currentDate,
        calendarView,
        onEventSelected,
        onCalendarIdChanged,

    } = porps;
    const startDayHour = porps.startDayHour ?? 7
    const endDayHour = porps.endDayHour ?? 17
    const {canEdit} = useAccount()
    const {calendarName} = useParams()
    const navigate = useNavigate()
    const location = useLocation()
    const getEvents = async () => {
        const state = location.state as Calendar[] | undefined | null
        if(state) {
            const calendar = state
            const startDate = getStartDateFromCurrentDate(currentDate, calendarView)
            const events: CalendarEvent[] = []
            if(calendar.length === 1) {
                onCalendarIdChanged(calendar[0].id!)
            }
            for(const c of calendar) {
                const result = await getEventsFrom(
                    c?.id!,
                    startDate,
                    calendarView
                )
                events.push(...result)
            }
            return events
        } else if(calendarName) {
            try {
                const c = await getCalendarByName(calendarName)
                onCalendarIdChanged(c.id!)
                navigate(`/calendar/${calendarName}`, {state: [c]})
            } catch (error) {
                navigate(`*`)
            }
        } else {
            navigate(`/`)
        }
        return []
    }
    const {data: events, refetch} = useQuery({
        queryKey: ['events', calendarName, calendarView, currentDate.startOf("day")],
        queryFn: getEvents,
        useErrorBoundary: true,
    })

    // Invalidates events when parameters change
    useEffect(() => {
        queryClient.invalidateQueries({queryKey: ['events', calendarName, calendarView, currentDate.startOf("day")]})
    }, [calendarName, location.state, calendarView, currentDate])

    const getAppointment = (c: CalendarEvent) => {
        const title: string = c.lecture.shortKey && (c.lecture.shortKey.length ?? 0) > 0 ? c.lecture.shortKey : c.lecture.title

        const a: AppointmentModel = {
            startDate: moment(c.start).toDate(),
            endDate: moment(c.end).toDate(),
            title: title,
            location: c.location,
            event: c,
        }
        if(c.repeat > 0) {
            switch(c.repeat) {
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
    }

    const CustomAppointment: React.FC<Appointments.AppointmentProps> = ({
                                                                            onClick,
                                                                            children,
                                                                            ...restProps
                                                                        }) => {
        return (
            <Appointments.Appointment
                {...restProps}
                onClick={(e) => {
                    if(canEdit) {
                        const {data: {event}} = e
                        if(!event) {
                            return
                        }
                        onEventSelected(event as CalendarEvent)
                    } else if(onClick) {
                        onClick(e)
                    }
                }}
            >
                {children}
            </Appointments.Appointment>
        )
    }


    return (
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
                data={events?.map(getAppointment) ?? []}
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
                    startDayHour={startDayHour}
                    endDayHour={endDayHour}
                />
                <WeekView
                    name={'week'}
                    startDayHour={startDayHour}
                    endDayHour={endDayHour}
                />
                <MonthView
                    name={'month'}
                />
                <Appointments
                    appointmentComponent={CustomAppointment}
                />
                <AppointmentTooltip showCloseButton
                                    contentComponent={AppointmentTooltipContent}
                                    headerComponent={AppointmentTooltipHeader}
                />
            </Scheduler>
        </Grid>
    )
}