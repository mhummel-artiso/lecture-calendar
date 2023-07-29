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
import React, { useEffect, useRef, useState } from 'react'
import { DatePicker } from '@mui/x-date-pickers/DatePicker'
import { TimePicker } from '@mui/x-date-pickers/TimePicker'
import { fetchCalendars } from '../services/CalendarService'
import { useQuery } from '@tanstack/react-query'
import { fetchLectures } from '../services/LectureService'
import { DateTimePicker } from '@mui/x-date-pickers'

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

    const eventStart = useRef<Date>()
    const eventEnd = useRef<Date>()
    const eventLocation = useRef<string>()
    const eventDescription = useRef<string>()
    const eventSerieEnd = useRef<Date>()

    const handleClose = () => {
        setSelectedCalendarId('')
        setSelectedLectureId('')
        handleDialogClose()
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
                            onChange={(value) => (eventStart.current = value)}
                            label="Start"
                        />
                        <DateTimePicker
                            onChange={(value) => (eventEnd.current = value)}
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
                                (eventSerieEnd.current = value)
                            }
                        />
                    </Stack>
                    <TextField
                        margin="dense"
                        id="name"
                        label="Vorlesungsort"
                        type="text"
                        onChange={(value) =>
                            (eventLocation.current = value.target.value)
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
                            (eventDescription.current = value.target.value)
                        }
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={handleClose}>Abbrechen</Button>
                <Button
                    type="submit"
                    onClick={() =>
                        console.log(
                            selectedCalendarId,
                            selectedLectureId,
                            selectedValue,
                            eventLocation.current,
                            eventDescription.current,
                            eventStart.current?.toISOString(),
                            eventEnd.current?.toISOString(),
                            eventSerieEnd.current?.toISOString()
                        )
                    }
                >
                    Hinzufügen
                </Button>
            </DialogActions>
        </Dialog>
    )
}
