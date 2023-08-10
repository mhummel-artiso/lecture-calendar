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
import { DateTimePicker, TimePicker } from '@mui/x-date-pickers'
import { AddEventType } from '../../hooks/useEventData'
import {
    CalendarEvent,
    CreateCalendarEvent,
    UpdateCalendarEvent,
    UpdateCalendarEventSeries
} from '../../models/calendarEvent'
import { Moment } from "moment/moment";
import moment from "moment";
import { getLectures } from "../../services/LectureService";
import { deleteEvent, deleteEventSeries, getCalendars } from "../../services/CalendarService";
import { DialogComponentProps } from "../../models/dialogComponentProps";
import DeleteIcon from '@mui/icons-material/Delete'


const serialList = [
    // dnr = do not repeat
    {value: 0, label: 'Nicht wiederholen'},
    {value: 1, label: 'Täglich wiederholen'},
    {value: 2, label: 'Wöchentlich wiederholen'},
    {value: 3, label: 'Monatlich wiederholen'},
]

export interface EditEventCallback {
    event?: UpdateCalendarEvent,
    eventSeries?: UpdateCalendarEventSeries
}

interface EventDialogComponentProps extends DialogComponentProps<CalendarEvent, CreateCalendarEvent, EditEventCallback> {
    calendarId: string
    onDeletedEvent: (event: CalendarEvent) => void;
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
    const [askEditSeries, setAskEditSeries] = useState<boolean>();
    const [askDeleteSeries, setAskDeleteSeries] = useState<boolean>(false);

    useEffect(() => {
        if(!currentValue) {
            resetValues()
        } else {
            setStartDate(moment(currentValue.start))
            setEndDate(moment(currentValue.end))
            setSelectedCalendarId(currentValue.calendarId ?? calendarId)
            setLocation(currentValue.location)
            setComment(currentValue.description ?? "")
            //TODO: überarbeiten
            setSerieEnd(moment(currentValue.endSeries ?? moment()))
            setSerie(currentValue.repeat)
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
        setSelectedCalendarId(calendarId ?? "")
        setSelectedLectureId("")
    }

    const handleClose = () => {
        resetValues()
        onDialogClose()
    }

    const handleAddOrEditEvent = (editSeries: boolean | undefined = undefined) => {
        if(currentValue) {
            if(onDialogEdit && editSeries) {
                const data: UpdateCalendarEventSeries = {
                    // TODO add ui for instructors
                    instructorsIds: currentValue.instructorsIds,
                    lastUpdateDate: currentValue.lastUpdateDate,
                    createdDate: currentValue.createdDate,
                    end: endDate,
                    start: startDate,
                    description: comment,
                    repeat: serie,
                    endSeries: serieEnd,
                    location: location,
                    lectureId: selectedLectureId,
                    seriesId: currentValue.serieId,
                    calendarId: currentValue.calendarId
                }
                onDialogEdit({
                    // TODO fix
                    eventSeries: data,
                    event: undefined
                });
            } else if(onDialogEdit && !editSeries) {
                const data: UpdateCalendarEvent = {
                    calendarId: currentValue.calendarId,
                    createdDate: currentValue.createdDate,

                    id: currentValue.id,
                    // TODO add ui for instructors
                    instructorsIds: currentValue.instructorsIds,
                    lastUpdateDate: currentValue.lastUpdateDate,
                    description: comment,
                    end: endDate,
                    start: startDate,
                    repeat: serie,
                    endSeries: serieEnd,
                    location: location,
                    lectureId: selectedLectureId
                }
                onDialogEdit({
                    event: data,
                    eventSeries: undefined
                })
            }
        } else if(onDialogAdd) {
            const data: CreateCalendarEvent = {
                lectureId: selectedLectureId,
                end: endDate,
                start: startDate,
                description: comment ?? undefined,
                location: location,
                endSeries: serieEnd ?? undefined,
                calendarId: selectedCalendarId,
                repeat: serie,
                // TODO add ui for instructors
                instructorsIds: []
            }
            onDialogAdd(data);
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
        mutationFn: async ({calendarId, event}: { calendarId: string, event: CalendarEvent }) => {
            const result = await deleteEvent(calendarId, event)
            onDeletedEvent(event)
            return result;
        },
        onSuccess: async (_) => {
            handleClose()
        },
    })
    const deleteEventSeriesMutation = useMutation({
        mutationFn: async ({calendarId, event}: { calendarId: string, event: CalendarEvent }) => {
            const result = await deleteEventSeries(calendarId, event.seriesId)
            onDeletedEvent(event)
            return result;
        },
        onSuccess: async (_) => {
            handleClose()
        },
    })

    const handleDeleteClick = (deleteSeries = false) => {
        if(!currentValue) {
            return
        }
        if(deleteSeries) {
            deleteEventSeriesMutation.mutate({
                calendarId: currentValue.calendarId,
                event: currentValue
            })
        } else {
            deleteEventMutation.mutate({
                calendarId: currentValue.calendarId,
                event: currentValue
            })
        }
    }
    const handleCancelAskDialog = () => {
        setAskDeleteSeries(false);
        setAskDeleteSeries(false);
    }
    const addOrEditContent = () => {
        return (
            <>
                <DialogTitle>
                    Event {currentValue ? "bearbeiten" : "hinzufügen"}
                </DialogTitle>
                <DialogContent sx={{width: '500px'}}>
                    <Stack spacing={2} sx={{margin: 1}}>
                        <Stack direction="row" spacing={2}>
                            {isCalendarLoading ? (
                                <CircularProgress/>
                            ) : (<TextField
                                fullWidth
                                value={selectedCalendarId}
                                onChange={(e) => setSelectedCalendarId(e.target.value)}
                                select
                                label="Kurs"
                                id={"kurs"}
                                required>
                                {(calendarsData ?? []).map((item) => (
                                    <MenuItem key={item.id} value={item.id}>
                                        {item.name}
                                    </MenuItem>
                                ))}
                            </TextField>)}
                            {isLectureLoading ? (
                                <CircularProgress/>
                            ) : (
                                <TextField
                                    fullWidth
                                    value={selectedLectureId}
                                    onChange={(e) => setSelectedLectureId(e.target.value)}
                                    select
                                    id={"vorlesung"}
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
                                key={"start"}
                                value={startDate}
                                onChange={value => {
                                    setStartDate(value!)
                                    setEndDate(value!)
                                }}
                                label="Start"
                            />
                            <TimePicker
                                value={endDate}
                                onChange={(e) => setEndDate(e!)}
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
                    {currentValue && (
                        <IconButton edge="end"
                                    aria-label="delete"
                                    onClick={(e) => {
                                        e.stopPropagation();
                                        if(currentValue.serieId !== undefined || currentValue?.serieId !== null) {
                                            setAskDeleteSeries(true)
                                        } else {
                                            handleDeleteClick(false)
                                        }
                                    }}
                        >
                            <DeleteIcon/>
                        </IconButton>)}
                    <Button onClick={handleClose}>Abbrechen</Button>
                    <Button onClick={() => currentValue ? setAskEditSeries(true) : handleAddOrEditEvent()}
                            disabled={!canClickAdd()}>{currentValue ? "Bearbeiten" : "Hinzufügen"}</Button>
                </DialogActions>
            </>
        )
    }
    const askForEditSeriesContent = () => {
        return (
            <>
                <DialogTitle>
                    Serie Bearbeiten?
                </DialogTitle>
                <DialogContent>
                    <Typography>
                        Wollen sie nur das aktuelle Ereignis oder die gesamte Serie Bearbeiten?
                    </Typography>
                </DialogContent>
                <DialogActions>
                    <Button onClick={handleCancelAskDialog}>Abbrechen</Button>
                    <Button onClick={() => {handleAddOrEditEvent(true)}}>Alle Elemente</Button>
                    <Button onClick={() => {handleAddOrEditEvent(false)}}>Nur diese</Button>
                </DialogActions>
            </>
        )
    }
    const askForDeleteSeriesContent = () => {
        return (
            <>
                <DialogTitle>
                    Serie Löschen?
                </DialogTitle>
                <DialogContent>
                    <Typography>
                        Wollen sie nur das aktuelle Ereignis oder die gesamte Serie löschen?
                    </Typography>
                </DialogContent>
                <DialogActions>
                    <Button onClick={() => handleCancelAskDialog()}>Abbrechen</Button>
                    <Button onClick={() => {handleDeleteClick(true)}}>Alle Elemente</Button>
                    <Button onClick={() => {handleDeleteClick(false)}}>Nur diese</Button>
                </DialogActions>
            </>
        )
    }
    return (
        <Dialog open={isDialogOpen} onClose={handleClose}>
            {askEditSeries && askForEditSeriesContent()}
            {askDeleteSeries && askForDeleteSeriesContent()}
            {!askEditSeries && !askDeleteSeries && addOrEditContent()}
        </Dialog>
    )
}
