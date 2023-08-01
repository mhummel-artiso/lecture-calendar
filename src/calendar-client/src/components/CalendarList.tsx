import {
    Accordion,
    AccordionDetails,
    AccordionSummary,
    Box,
    Fab,
    Grid,
    IconButton,
    List,
    ListItem,
    ListItemText,
    Typography,
} from '@mui/material'
import React, { useState } from 'react'
import DeleteIcon from '@mui/icons-material/Delete'
import ExpandMoreIcon from '@mui/icons-material/ExpandMore'
import { useMutation, useQuery } from '@tanstack/react-query'
import { axiosInstance } from '../utils/axiosInstance'
import { fetchCalendars } from '../services/CalendarService'

export const CalendarList = () => {
    const [expanded, setExpanded] = useState('')

    const handleExpanded = (name: string) => {
        if (name === expanded) {
            setExpanded('')
        } else {
            setExpanded(name)
        }
    }

    const calendarQuery = useQuery({
        queryKey: ['calendars'],
        queryFn: fetchCalendars,
    })

    const deleteCalendar = useMutation({
        mutationFn: (calendarId: string) => {
            return axiosInstance.delete(`Calendar/${calendarId}`)
        },
        onSuccess: (data) => {
            calendarQuery.refetch()
        },
    })

    return (
        <Accordion
            expanded={expanded === 'calendar'}
            onChange={() => handleExpanded('calendar')}
        >
            <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                <Typography>Kalender</Typography>
            </AccordionSummary>
            <AccordionDetails>
                <List>
                    {calendarQuery.data?.map(
                        (calendar, index) => {
                            return (
                                <ListItem
                                    divider
                                    key={index}
                                    secondaryAction={
                                        <IconButton
                                            edge="end"
                                            aria-label="delete"
                                            onClick={() =>
                                                deleteCalendar.mutate(
                                                    calendar.id!
                                                )
                                            }
                                        >
                                            <DeleteIcon />
                                        </IconButton>
                                    }
                                >
                                    <ListItemText
                                        primary={calendar.name}
                                    />
                                </ListItem>
                            )
                        }
                    )}
                </List>
            </AccordionDetails>
        </Accordion>
    )
}

