import React from 'react'
import { AppointmentTooltip } from '@devexpress/dx-react-scheduler-material-ui'
import { CalendarEvent } from '../../models/calendarEvent'
import { Avatar, Chip, Grid, Typography } from '@mui/material'

// Custom Appointment Tooltip
export const AppointmentTooltipContent: React.FC<
    AppointmentTooltip.ContentProps
> = ({ appointmentData, ...restProps }) => {
    const event = appointmentData?.event as CalendarEvent
    return (
        <AppointmentTooltip.Content
            {...restProps}
            appointmentData={appointmentData}
        >
            <Grid
                sx={{ mt: 1, ml: 1 }}
                container
                alignItems="left"
                direction="column"
                spacing={1}
            >
                {appointmentData?.location && (
                    <Grid item>
                        <Typography fontWeight="bold">
                            Veranstaltungsort:
                        </Typography>
                        <Typography sx={{ ml: 2 }}>
                            {' '}
                            {appointmentData?.location}
                        </Typography>
                    </Grid>
                )}
                {event.instructors.length > 0 && (
                    <Grid item container spacing={1}>
                        <Grid item>
                            <Typography fontWeight="bold">Dozenten:</Typography>
                        </Grid>
                        <Grid item container direction="row" spacing={1}>
                            {event.instructors.map((i) => (
                                <Grid item key={i.id}>
                                    <Chip
                                        avatar={<Avatar alt={i.name} />}
                                        label={i.name}
                                    />
                                </Grid>
                            ))}
                        </Grid>
                    </Grid>
                )}
                {event.description && (
                    <Grid item>
                        <Typography fontWeight="bold">Hinweis:</Typography>
                        <Typography sx={{ ml: 2 }}>
                            {event.description}
                        </Typography>
                    </Grid>
                )}
            </Grid>
        </AppointmentTooltip.Content>
    )
}

export const AppointmentTooltipHeader: React.FC<
    AppointmentTooltip.HeaderProps
> = ({ appointmentData, ...restProps }) => {
    const event = appointmentData?.event as CalendarEvent
    return (
        <AppointmentTooltip.Header
            {...restProps}
            appointmentData={appointmentData}
        >
            {event.lecture ? (
                <Grid
                    sx={{ mt: 1, ml: 1 }}
                    container
                    alignItems="Center"
                    direction="column"
                    spacing={1}
                >
                    <Grid item>
                        <Typography variant={'h5'}>Veranstaltung</Typography>
                    </Grid>
                    {event.lecture?.shortKey && (
                        <Grid item>
                            <Typography fontWeight="bold">
                                {event.lecture.title}
                            </Typography>
                        </Grid>
                    )}
                    {event.lecture?.description && (
                        <Grid item>
                            <Typography>{event.lecture.description}</Typography>
                        </Grid>
                    )}
                </Grid>
            ) : (
                <Grid
                    sx={{ mt: 1, ml: 1 }}
                    container
                    alignItems="Center"
                    direction="column"
                    spacing={1}
                >
                    <Grid item>
                        <Typography variant={'h5'}>Fehler!</Typography>
                    </Grid>
                </Grid>
            )}
        </AppointmentTooltip.Header>
    )
}
