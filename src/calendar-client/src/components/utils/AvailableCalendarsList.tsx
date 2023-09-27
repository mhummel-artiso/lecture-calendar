import {
    Box,
    CircularProgress,
    List,
    ListItem,
    ListItemButton,
    ListItemIcon,
    ListItemText,
} from '@mui/material'
import CalendarTodayIcon from '@mui/icons-material/CalendarToday'
import React, { FC, useEffect, useState } from 'react'
import { Calendar } from '../../models/calendar'
import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { getAssignedCalendars } from '../../services/CalendarService'

interface Props {
    disablePadding?: boolean
}

// Calendars that show in menu
export const AvailableCalendarsList: FC<Props> = ({ disablePadding }) => {
    const navigate = useNavigate()
    const [calendars, setCalendars] = useState<Calendar[]>([])

    const { isLoading, data } = useQuery({
        queryKey: ['calendars'],
        queryFn: getAssignedCalendars,
        useErrorBoundary: true,
    })
    useEffect(() => {
        setCalendars(data ?? [])
    }, [data])
    return isLoading ? (
        <Box margin={2}>
            <CircularProgress />
        </Box>
    ) : (
        <List>
            {!calendars ||
                (data?.length == 0 && (
                    <ListItem disablePadding={disablePadding}>
                        <ListItemText primary={'Kein Kalender verfügbar'} />
                    </ListItem>
                ))}
            {/* Option to show all calendars together, useful for lecturers */}
            {calendars && calendars.length > 1 && (
                <ListItem disablePadding={disablePadding}>
                    <ListItemButton
                        onClick={() =>
                            navigate(`/calendar`, {
                                state: [...calendars],
                            })
                        }
                    >
                        <ListItemIcon>
                            <CalendarTodayIcon />
                        </ListItemIcon>
                        <ListItemText primary={'Alle Events anzeigen'} />
                    </ListItemButton>
                </ListItem>
            )}
            {calendars.map((calendar, index) => (
                <ListItem key={index} disablePadding={disablePadding}>
                    <ListItemButton
                        onClick={() =>
                            navigate(`/calendar/${calendar.name}`, {
                                state: [calendar],
                            })
                        }
                    >
                        <ListItemIcon>
                            <CalendarTodayIcon />
                        </ListItemIcon>
                        <ListItemText primary={calendar.name} />
                    </ListItemButton>
                </ListItem>
            ))}
        </List>
    )
}
