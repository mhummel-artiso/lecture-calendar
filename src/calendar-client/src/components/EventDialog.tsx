import {
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    MenuItem,
    Stack,
    TextField,
} from '@mui/material'
import React, { useRef, useState } from 'react'
import { DatePicker } from '@mui/x-date-pickers/DatePicker'
import { fetchCalendars } from '../services/CalendarService'
import { useQuery } from '@tanstack/react-query'
import { fetchLectures } from '../services/LectureService'
import { DateTimePicker } from '@mui/x-date-pickers'
import { AddEventType, useAddEvent } from "../hooks/useEventData";
import { CreateCalendarEvent } from "../models/calendarEvent";


interface Props {
    isDialogOpen: boolean
    handleDialogClose: () => void
}

export const EventDialog = ({ isDialogOpen, handleDialogClose }: Props) => {
    const { data: calendarsData } = useQuery({
        queryKey: ['calendars'],
        queryFn: fetchCalendars,
    })

    const { data: lectureData } = useQuery({
        queryKey: ['lectures'],
        queryFn: fetchLectures,
    })

    const serialList = [
        { value: 'dnr', label: 'Einzeltermin' },
        { value: 'weekly', label: 'Wöchentlich wiederholen' },
        { value: 'monthly', label: 'Monatlich wiederholen' },
    ]

    const [selectedValue, setSelectedValue] = useState(serialList[0].value)
    const [selectedCalendarId, setSelectedCalendarId] = React.useState('') // Change to use course that Person is currently on its calendar
    const [selectedLectureId, setSelectedLectureId] = React.useState('')

    const { mutate : addEvent } = useAddEvent()

    const eventStartRef = useRef<Date>()
    const eventEndRef = useRef<Date>()
    const eventLocationRef = useRef<string>()
    const eventDescriptionRef = useRef<string>()
    const eventSerieEndRef = useRef<Date>()

    const handleClose = () => {
        handleDialogClose()

        eventStartRef.current = undefined
        eventEndRef.current = undefined
        eventLocationRef.current = undefined
        eventDescriptionRef.current = undefined
        eventSerieEndRef.current = undefined

        setSelectedValue(serialList[0].value)
        setSelectedCalendarId('')
        setSelectedLectureId('')
    }

    const handleAddEvent = () => {
        const location = eventLocationRef.current;
        const start = eventStartRef.current;
        const end = eventEndRef.current;
        const endSeries = eventSerieEndRef.current;

        // Check if undefined
        if(!selectedCalendarId) return;
        if(!selectedLectureId) return;
        if(!location) return;
        if(!start) return;
        if(!end) return;

        const eventToAdd : CreateCalendarEvent = {
            lectureId: selectedLectureId,
            end: end.toISOString(),
            start: start.toISOString(),
            description: eventDescriptionRef.current,
            location: location,
            endSeries: endSeries?.toISOString()
        }

        addEvent({event: eventToAdd, calendarId: selectedCalendarId} as AddEventType)
    }

    return (
        <Dialog open={isDialogOpen} onClose={handleClose}>
            <DialogTitle>Event hinzufügen</DialogTitle>
            <DialogContent sx={{ width: '500px' }}>
                <Stack>
                    <TextField
                        margin="dense"
                        value={selectedCalendarId}
                        onChange={(e) => setSelectedCalendarId(e.target.value)}
                        select
                        label="Kurs"
                    >
                        {calendarsData?.map((item) => (
                            <MenuItem key={item.id} value={item.id}>
                                {item.name}
                            </MenuItem>
                        ))}
                    </TextField>
                    <TextField
                        margin="dense"
                        value={selectedLectureId}
                        onChange={(e) => setSelectedLectureId(e.target.value)}
                        select
                        label="Vorlesung"
                    >
                        {lectureData?.map((item) => (
                            <MenuItem key={item.id} value={item.id}>
                                {item.title}
                            </MenuItem>
                        ))}
                    </TextField>
                    <Stack direction="row" spacing={2} sx={{ mt: 1, mb: 1 }}>
                        <DateTimePicker
                            onChange={(value) => (eventStartRef.current = value)}
                            label="Start"
                        />
                        <DateTimePicker
                            onChange={(value) => (eventEndRef.current = value)}
                            label="Ende"
                        />
                    </Stack>
                    <Stack direction="row">
                        <TextField
                            margin="dense"
                            select
                            fullWidth
                            defaultValue={serialList[0].value}
                            value={selectedValue}
                            onChange={(event) =>
                                setSelectedValue(event.target.value)
                            }
                        >
                            {serialList.map((item, index) => (
                                <MenuItem key={index} value={item.value}>
                                    {item.label}
                                </MenuItem>
                            ))}
                        </TextField>
                        <DatePicker
                            label="Serienende"
                            sx={{ ml: 2, mt: 1, mb: 1 }}
                            disabled={selectedValue === serialList[0].value}
                            onChange={(value) =>
                                (eventSerieEndRef.current = value)
                            }
                        />
                    </Stack>
                    <TextField
                        margin="dense"
                        id="name"
                        label="Vorlesungsort"
                        type="text"
                        onChange={(value) =>
                            (eventLocationRef.current = value.target.value)
                        }
                    />
                    <TextField
                        multiline
                        margin="dense"
                        id="comment"
                        type="text"
                        label="Zusätzliche Infos"
                        maxRows={4}
                        onChange={(value) =>
                            (eventDescriptionRef.current = value.target.value)
                        }
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={handleClose}>Abbrechen</Button>
                <Button
                    onClick={handleAddEvent}
                >
                    Hinzufügen
                </Button>
            </DialogActions>
        </Dialog>
    )
}
