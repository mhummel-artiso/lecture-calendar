import {
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle, FormControl, Grid,
    MenuItem,
    Stack,
    TextField,
} from '@mui/material'
import React, { FormEventHandler, useRef, useState } from 'react'
import { DatePicker } from '@mui/x-date-pickers/DatePicker'
import { fetchCalendars } from '../../services/CalendarService'
import { useQuery } from '@tanstack/react-query'
import { fetchLectures } from '../../services/LectureService'
import { DateTimePicker } from '@mui/x-date-pickers'
import { AddEventType, useAddEvent } from '../../hooks/useEventData'
import { CreateCalendarEvent } from '../../models/calendarEvent'
import { Dayjs } from "dayjs";

const serialList = [
    // dnr = doNotRepeat
    {value: 'dnr', label: 'Einzeltermin'},
    {value: 'weekly', label: 'Wöchentlich wiederholen'},
    {value: 'monthly', label: 'Monatlich wiederholen'},
]

interface Props {
    isDialogOpen: boolean
    handleDialogClose: () => void
}

export const EventDialog = ({isDialogOpen, handleDialogClose}: Props) => {
    const {data: calendarsData} = useQuery({
        queryKey: ['calendars'],
        queryFn: fetchCalendars,
    })

    const {data: lectureData} = useQuery({
        queryKey: ['lectures'],
        queryFn: fetchLectures,
    })

    const [selectedCalendarId, setSelectedCalendarId] = React.useState('') // Change to use course that Person is currently on its calendar
    const [selectedLectureId, setSelectedLectureId] = React.useState('')

    const {mutate: addEvent, isSuccess} = useAddEvent()
    const [startDate, setStartDate] = useState<Dayjs | null>();
    const [endDate, setEndDate] = useState<Dayjs | null>(null);
    const [location, setLocation] = useState<string | null>(null)
    const [comment, setComment] = useState<string | null>(null);
    const [serieEnd, setSerieEnd] = useState<Dayjs | null>(null);
    const [serie, setSerie] = useState<string>(serialList[0].value);

    const handleClose = () => {
        handleDialogClose()
        setStartDate(null)
        setEndDate(null)
        setSerie(serialList[0].value);
        setLocation(null)
        setComment(null)
        setSerieEnd(null)
        setSelectedCalendarId('')
        setSelectedLectureId('')
    }

    const handleAddEvent = () => {
        // Check if undefined
        const eventToAdd: CreateCalendarEvent = {
            lectureId: selectedLectureId,
            end: endDate!,
            start: startDate!,
            description: comment ?? undefined,
            location: location!,
            endSeries: serieEnd ?? undefined,
        }

        addEvent({
            event: eventToAdd,
            calendarId: selectedCalendarId,
        } as AddEventType)
        if(isSuccess) {
            handleClose()
        }
    }
    const canClickAdd = () => {
        let isValidSerie = true;
        if(serie != serialList[0].value) {
            isValidSerie = !!serieEnd;
        }
        return selectedCalendarId &&
            selectedLectureId &&
            location &&
            startDate &&
            endDate &&
            isValidSerie;
    }

    return (
        <Dialog open={isDialogOpen} onClose={handleClose}>
            <DialogTitle>Event hinzufügen</DialogTitle>
            <DialogContent sx={{width: '500px'}}>
                <Stack spacing={2} sx={{margin: 1}}>
                    <Stack direction="row" spacing={2}>
                        <TextField
                            fullWidth
                            value={selectedCalendarId}
                            onChange={(e) => setSelectedCalendarId(e.target.value)}
                            select
                            label="Kurs"
                            required
                        >
                            {(calendarsData ?? []).map((item) => (
                                <MenuItem key={item.id} value={item.id}>
                                    {item.name}
                                </MenuItem>
                            ))}
                        </TextField>
                        <TextField
                            fullWidth
                            value={selectedLectureId}
                            onChange={(e) => setSelectedLectureId(e.target.value)}
                            select
                            label="Vorlesung"
                        >
                            {(lectureData ?? []).map((item) => (
                                <MenuItem key={item.id} value={item.id}>
                                    {item.title}
                                </MenuItem>
                            ))}
                        </TextField>
                    </Stack>
                    <Stack direction="row" spacing={2} sx={{mt: 1, mb: 1}}>
                        <DateTimePicker
                            value={startDate}
                            onChange={value => {
                                setStartDate(value)
                                if(endDate == null) {
                                    setEndDate(value)
                                }
                            }}
                            label="Start"
                        />
                        <DateTimePicker
                            value={endDate}
                            onChange={setEndDate}
                            label="Ende"
                        />
                    </Stack>
                    <Stack direction="row">
                        <TextField
                            margin="dense"
                            select
                            fullWidth
                            defaultValue={serialList[0].value}
                            value={serie}
                            onChange={(event) =>
                                setSerie(event?.target?.value)
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
                            sx={{ml: 2, mt: 1, mb: 1}}
                            disabled={serie === serialList[0].value}
                            value={serieEnd}
                            onChange={setSerieEnd}
                        />
                    </Stack>
                    <TextField
                        margin="dense"
                        label="Vorlesungsort"
                        type="text"
                        value={location}
                        onChange={(e) => setLocation(e.target.value)}
                    />
                    <TextField
                        multiline
                        rows={2}
                        margin="dense"
                        type="text"
                        label="Zusätzliche Infos"
                        maxRows={4}
                        value={comment}
                        onChange={(e) => setComment(e.target.value)}
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={handleClose}>Abbrechen</Button>
                <Button onClick={handleAddEvent} disabled={!canClickAdd()}>Hinzufügen</Button>
            </DialogActions>
        </Dialog>
    )
}
