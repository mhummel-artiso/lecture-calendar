import {
    Accordion,
    AccordionDetails,
    AccordionSummary,
    Box,
    Button,
    Fab,
    Grid,
    IconButton,
    List,
    ListItem,
    ListItemText,
    Typography,
} from '@mui/material'
import React, { FC, useState } from 'react'
import DeleteIcon from '@mui/icons-material/Delete'
import ExpandMoreIcon from '@mui/icons-material/ExpandMore'
import { useMutation, useQuery } from '@tanstack/react-query'
import { axiosInstance } from '../../../utils/axiosInstance'
import { fetchCalendars } from '../../../services/CalendarService'
import { Lecture } from '../../../models/lecture'
import { Calendar } from '../../../models/calendar'
import AddIcon from '@mui/icons-material/Add'
import { CalendarDialog } from './CalendarDialog'


interface ComponentProps{
}

export const CalendarList:FC<ComponentProps> = (props) => {
    const [expanded, setExpanded] = useState('')
    const [isDialogOpen, setIsDialogOpen] = useState(false);
    const [selectedCalendar, setSelectedCalendar] = useState<Calendar|null>(null);

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
        <>
        <Accordion
            expanded={expanded === 'calendar'}
            onChange={() => handleExpanded('calendar')}
        >
            <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                <Typography>Kalender</Typography>
            </AccordionSummary>
            <AccordionDetails>
            <Button variant="outlined" startIcon={<AddIcon />} onClick= {()=> {setSelectedCalendar(null); setIsDialogOpen(true)}}>Kalender hinzufügen</Button>
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
                                    onClick={() => {setIsDialogOpen(true); setSelectedCalendar(calendar)}}
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
        <CalendarDialog
                isDialogOpen={isDialogOpen}
                handleDialogAbort={() => setIsDialogOpen(false)}
                currentCalendar={selectedCalendar}
        />
        </>
    )
}

