import {
    Button, CircularProgress,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    IconButton,
    Typography,
    MenuItem,
    Stack,
    TextField,
} from '@mui/material'
import React, { FC, useEffect, useState } from 'react'
import { DatePicker } from '@mui/x-date-pickers/DatePicker'
import { useMutation, useQuery } from '@tanstack/react-query'
import { DateTimePicker } from '@mui/x-date-pickers'
import { AddEventType } from '../../hooks/useEventData'
import { CalendarEvent, CreateCalendarEvent } from '../../models/calendarEvent'
import {Moment}  from "moment/moment";
import  moment  from "moment";
import { getLectures } from "../../services/LectureService";
import { deleteEvent, getCalendars } from "../../services/CalendarService";
import { DialogComponentProps } from "../../models/dialogComponentProps";
import DeleteIcon from '@mui/icons-material/Delete'


const serialList = [
    // dnr = do not repeat
    {value: 0, label: 'Nicht wiederholen'},
    {value: 1, label: 'Täglich wiederholen'},
    {value: 2, label: 'Wöchentlich wiederholen'},
    {value: 3, label: 'Monatlich wiederholen'},
]

interface EventDialogComponentProps extends DialogComponentProps<CalendarEvent, CreateCalendarEvent, CalendarEvent> {
    calendarId: string
    onDeletedEvent: (event:CalendarEvent)=>void;
}

export const EventDialog: FC<EventDialogComponentProps> = ({
                                isDialogOpen,
                                onDialogClose,
                                onDeletedEvent,
                                onDialogAdd,
                                onDialogEdit,
                                currentValue,
                                calendarId
                            }: EventDialogComponentProps) => {

    const {data: calendarsData, isLoading: isCalendarLoading} = useQuery({
        queryKey: ['calendars'],
        queryFn: getCalendars,
        useErrorBoundary: true
    })

    const {data: lectureData, isLoading: isLectureLoading} = useQuery({
        queryKey: ['lectures'],
        queryFn: getLectures,
        useErrorBoundary: true
    })

    const [selectedCalendarId, setSelectedCalendarId] = React.useState<string>(calendarId) 
    const [selectedLectureId, setSelectedLectureId] = React.useState<string>("")
    const [startDate, setStartDate] = useState<Moment>(moment());
    const [endDate, setEndDate] = useState<Moment>(moment());
    const [location, setLocation] = useState<string>("")
    const [comment, setComment] = useState<string>("");
    const [serieEnd, setSerieEnd] = useState<Moment>(moment());
    const [serie, setSerie] = useState<number>(serialList[0].value);

    useEffect(() => {
        if(!currentValue) {
            resetValues()
        } else {
            setStartDate(moment( currentValue.start))
            setEndDate(moment(currentValue.end))
            setSelectedCalendarId(currentValue.calendarId ?? calendarId)
            setLocation(currentValue.location)
            setComment(currentValue.description ?? "")
            //TODO: überarbeiten
            setSerieEnd(moment(currentValue.endSeries ?? moment()))
            setSerie(currentValue.rotation)
            setSelectedLectureId(currentValue.lecture.id!)
        }
    }, [currentValue])
    
    const resetValues = () => {
        setStartDate(moment())
        setEndDate(moment())
        setSerie(serialList[0].value);
        setLocation("")
        setComment("")
        setSerieEnd(moment())
        setSelectedCalendarId(calendarId??"")
        setSelectedLectureId("")
    }
    const handleClose = () => {
        resetValues()
        onDialogClose()
    }

    const handleAddEvent = () => {
        // Check if undefined
        
        if(currentValue) {
            // TODO fix
            if (onDialogEdit)
                onDialogEdit({});
        } else {
            if (onDialogAdd)
                onDialogAdd({
                    lectureId: selectedLectureId,
                    end: endDate!,
                    start: startDate!,
                    description: comment ?? undefined,
                    location: location!,
                    endSeries: serieEnd ?? undefined,
                    calendarId:selectedCalendarId,
                    rotation:serie,
                });
        }
        handleClose()
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

    const deleteEventMutation = useMutation({
        mutationFn: async ({calendarId, event}:{calendarId: string, event: CalendarEvent}) => {
            const result = await deleteEvent(calendarId, event)
            onDeletedEvent(event)
            handleClose()
            return result;
        },
        onSuccess: async (_) => {
            //await refetch()
        },
    })
    
    return (
        <Dialog open={isDialogOpen} onClose={handleClose}>
            <DialogTitle>
                    Event hinzufügen 
                {currentValue && (<IconButton edge="end"
                                            aria-label="delete"
                                            onClick={(e) => {
                                                e.stopPropagation();
                                                deleteEventMutation.mutate({
                                                    calendarId:currentValue.calendarId,
                                                    event: currentValue!
                                                })
                                            }}
                                        >
                                            <DeleteIcon/>
                                        </IconButton>)}
                </DialogTitle>
            <DialogContent sx={{width: '500px'}}>
                <Stack spacing={2} sx={{margin: 1}}>
                    <Stack direction="row" spacing={2}>
                        {isCalendarLoading ? (<CircularProgress/>): (<TextField
                            fullWidth
                            value={selectedCalendarId}
                            onChange={(e) => setSelectedCalendarId(e.target.value)}
                            select
                            label="Kurs"
                            required>
                            {(calendarsData ?? []).map((item) => (
                                <MenuItem key={item.id} value={item.id}>
                                    {item.name}
                                </MenuItem>
                            ))}
                        </TextField>)}
                        {isLectureLoading?(<CircularProgress/>):(
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
                        )}
                    </Stack>
                    <Stack direction="row" spacing={2} sx={{mt: 1, mb: 1}}>
                        <DateTimePicker
                            value={startDate}
                            onChange={value => {
                                setStartDate(value!)
                                if(endDate == null) {
                                    setEndDate(value!)
                                }
                            }}
                            label="Start"
                        />
                        <DateTimePicker
                            value={endDate}
                            onChange={(e)=>setEndDate(e!)}
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
                                setSerie(Number(event?.target?.value))
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
                            onChange={(e) => setSerieEnd(e!)}
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
                <Button onClick={handleAddEvent} disabled={!canClickAdd()}>{currentValue?"Bearbeiten":"Hinzufügen"}</Button>
            </DialogActions>
        </Dialog>
    )
}
