import {
    Accordion,
    AccordionDetails,
    AccordionSummary,
    Box,
    Button,
    CircularProgress,
    drawerClasses,
    Fab,
    Grid,
    IconButton,
    List,
    ListItem,
    ListItemButton,
    ListItemSecondaryAction,
    ListItemText,
    Typography,
} from '@mui/material'
import React, { FC, useState } from 'react'
import DeleteIcon from '@mui/icons-material/Delete'
import ExpandMoreIcon from '@mui/icons-material/ExpandMore'
import { useMutation, useQuery } from '@tanstack/react-query'
import {
    addCalendar,
    deleteCalendar,
    editCalendar,
    getCalendars,
} from '../../../services/CalendarService'
import { Calendar } from '../../../models/calendar'
import AddIcon from '@mui/icons-material/Add'
import { CalendarDialog } from './CalendarDialog'

export const CalendarList: FC = () => {
    const [isOpen, setIsOpen] = useState<boolean>(false)
    const [isDialogOpen, setIsDialogOpen] = useState(false)
    const [selectedCalendar, setSelectedCalendar] = useState<Calendar | null>(
        null
    )

    const handleExpanded = () => {
        setIsOpen((prevState) => !prevState)
    }

    const { isLoading, data, refetch } = useQuery({
        queryKey: ['calendars'],
        queryFn: getCalendars,
        useErrorBoundary: true,
    })

    const deleteCalendarMutation = useMutation({
        mutationFn: async (calendarId: string) => {
            return await deleteCalendar(calendarId)
        },
        onSuccess: async (_) => {
            await refetch()
        },
    })
    const addCalendarMutation = useMutation({
        mutationFn: async (calendar: Calendar) => {
            return await addCalendar(calendar)
        },
        onSuccess: async (_) => {
            await refetch()
        },
    })
    const editCalendarMutation = useMutation({
        mutationFn: async (calendar: Calendar) => {
            if (!calendar.id) {
                throw new Error('Ungültige Kalender Id')
            }
            return await editCalendar(calendar.id, calendar)
        },
        onSuccess: async (_) => {
            await refetch()
            setIsDialogOpen(false)
        },
    })
    return (
        <>
            <Accordion expanded={isOpen} onChange={handleExpanded}>
                <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                    <Typography>Kalender</Typography>
                </AccordionSummary>
                <AccordionDetails>
                    {isLoading ? (
                        <Box margin={1}>
                            <CircularProgress />
                        </Box>
                    ) : (
                        <>
                            <Button
                                variant="outlined"
                                startIcon={<AddIcon />}
                                onClick={() => {
                                    setSelectedCalendar(null)
                                    setIsDialogOpen(true)
                                }}
                            >
                                Kalender hinzufügen
                            </Button>
                            <List>
                                {data?.map((calendar, index) => (
                                    <ListItemButton
                                        divider
                                        key={index}
                                        onClick={() => {
                                            setIsDialogOpen(true)
                                            setSelectedCalendar(calendar)
                                        }}
                                    >
                                        <ListItemText primary={calendar.name} />
                                        <ListItemSecondaryAction>
                                            <IconButton
                                                edge="end"
                                                aria-label="delete"
                                                onClick={(e) => {
                                                    e.stopPropagation()
                                                    deleteCalendarMutation.mutate(
                                                        calendar.id!
                                                    )
                                                }}
                                            >
                                                <DeleteIcon />
                                            </IconButton>
                                        </ListItemSecondaryAction>
                                    </ListItemButton>
                                ))}
                            </List>
                        </>
                    )}
                </AccordionDetails>
            </Accordion>
            {isDialogOpen && (
                <CalendarDialog
                    isDialogOpen={isDialogOpen}
                    onDialogClose={() => setIsDialogOpen(false)}
                    currentValue={selectedCalendar}
                    onDialogAdd={addCalendarMutation.mutate}
                    onDialogEdit={editCalendarMutation.mutate}
                />
            )}
        </>
    )
}
