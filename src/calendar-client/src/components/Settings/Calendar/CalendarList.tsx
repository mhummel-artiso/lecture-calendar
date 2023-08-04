import {
    Accordion,
    AccordionDetails,
    AccordionSummary,
    Box,
    Button, drawerClasses,
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
import { addCalendar, deleteCalendar, editCalendar, getCalendars } from '../../../services/CalendarService'
import { Calendar } from '../../../models/calendar'
import AddIcon from '@mui/icons-material/Add'
import { CalendarDialog } from './CalendarDialog'

export const CalendarList: FC = () => {
    const [expanded, setExpanded] = useState('')
    const [isDialogOpen, setIsDialogOpen] = useState(false);
    const [selectedCalendar, setSelectedCalendar] = useState<Calendar | null>(null);

    const handleExpanded = (name: string) => {
        if(name === expanded) {
            setExpanded('')
        } else {
            setExpanded(name)
        }
    }

    const calendarQuery = useQuery({
        queryKey: ['calendars'],
        queryFn: getCalendars,
    })

    const deleteCalendarMutation = useMutation({
        mutationFn: async (calendarId: string) => {
            return await deleteCalendar(calendarId)
        }
        ,
        onSuccess: async (_) => {
            await calendarQuery.refetch()
        },
    })
    const addCalendarMutation = useMutation({
        mutationFn: async (calendar: Calendar) => {
            return await addCalendar(calendar)
        },
        onSuccess: async (_) => {
            await calendarQuery.refetch();
            setIsDialogOpen(false)
        }
    })
    const editCalendarMutation = useMutation({
        mutationFn: async (calendar: Calendar) => {
            if(!calendar.id) {
                throw new Error("Ungültige Kalender Id");
            }
            return await editCalendar(calendar.id, calendar);
        },
        onSuccess: async (_) => {
            await calendarQuery.refetch()
            setIsDialogOpen(false);
        }
    })
    return (
        <>
            <Accordion
                expanded={expanded === 'calendar'}
                onChange={() => handleExpanded('calendar')}
            >
                <AccordionSummary expandIcon={<ExpandMoreIcon/>}>
                    <Typography>Kalender</Typography>
                </AccordionSummary>
                <AccordionDetails>
                    <Button variant="outlined" startIcon={<AddIcon/>} onClick={() => {
                        setSelectedCalendar(null);
                        setIsDialogOpen(true)
                    }}>Kalender hinzufügen</Button>
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
                                                    deleteCalendarMutation.mutate(
                                                        calendar.id!
                                                    )
                                                }
                                            >
                                                <DeleteIcon/>
                                            </IconButton>
                                        }
                                        onClick={() => {
                                            setIsDialogOpen(true);
                                            setSelectedCalendar(calendar)
                                        }}
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
            {isDialogOpen &&
                <CalendarDialog
                    isDialogOpen={isDialogOpen}
                    handleDialogAbort={() => setIsDialogOpen(false)}
                    currentValue={selectedCalendar}
                    handleDialogAdd={addCalendarMutation.mutate}
                    handleDialogEdit={editCalendarMutation.mutate}

                />
            }

        </>
    )
}

