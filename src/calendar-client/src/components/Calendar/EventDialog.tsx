import {
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    IconButton,
    Typography,
    MenuItem,
    Stack,
    TextField,
    Accordion,
    AccordionSummary,
    AccordionDetails,
    Stepper,
    Step,
    Box,
    StepLabel,
} from '@mui/material'
import ExpandMoreIcon from '@mui/icons-material/ExpandMore'
import React, { FC, useEffect, useState } from 'react'
import { DatePicker } from '@mui/x-date-pickers/DatePicker'
import { useMutation } from '@tanstack/react-query'
import { DateTimePicker, TimePicker } from '@mui/x-date-pickers'
import {
    CalendarEvent, CalendarEventBase,
    CreateCalendarEvent,
    UpdateCalendarEvent,
    UpdateCalendarEventSeries
} from '../../models/calendarEvent'
import { Moment } from "moment/moment";
import moment from "moment";
import { deleteEvent, deleteEventSeries } from "../../services/CalendarService";
import { DialogComponentProps } from "../../models/dialogComponentProps";
import { EditSeriesDialogContent } from './EditSeriesDialogContent'
import { renderTimeViewClock } from '@mui/x-date-pickers/timeViewRenderers';
import { useAccount } from '../../hooks/useAccount'
import { Instructor } from '../../models/instructor'
import { CalendarSelect } from "./selects/CalendarSelect";
import { LectureSelect } from "./selects/LectureSelect";
import { InstructorSelect } from "./selects/InstructorSelect";
import { LayoutDisplayItem } from "./DialogInterfaces";
import { AccordionLayout } from "./layout/AccordionLayout";
import { StepperLayout } from "./layout/StepperLayout";


const serialList = [
    // dnr = do not repeat
    {value: 0, label: 'Nicht wiederholen'},
    {value: 1, label: 'Täglich wiederholen'},
    {value: 2, label: 'Wöchentlich wiederholen'},
    {value: 3, label: 'Monatlich wiederholen'},
]

export interface EditEventCallback {
    calendarId: string
    event?: UpdateCalendarEvent,
    eventSeries?: UpdateCalendarEventSeries
}

interface EventDialogComponentProps extends DialogComponentProps<CalendarEvent, CreateCalendarEvent, EditEventCallback> {
    calendarId: string
    onDeletedEvent: (event: CalendarEvent) => void;
}

export type TextFieldViewType = 'required' | 'time' | 'optional';
export const EventDialog: FC<EventDialogComponentProps> = ({
                                                               isDialogOpen,
                                                               onDialogClose,
                                                               onDeletedEvent,
                                                               onDialogAdd,
                                                               onDialogEdit,
                                                               currentValue,
                                                               calendarId
                                                           }: EventDialogComponentProps) => {
    const [selectedCalendarId, setSelectedCalendarId] = React.useState<string>(calendarId)
    const [selectedLectureId, setSelectedLectureId] = React.useState<string>("")
    const [startDate, setStartDate] = useState<Moment>(moment());
    const [endDate, setEndDate] = useState<Moment>(moment());
    const [location, setLocation] = useState<string>("")
    const [description, setDescription] = useState<string>("");
    const [serieEnd, setSerieEnd] = useState<Moment>(moment());
    const [serie, setSerie] = useState<number>(serialList[0].value);
    const [askEditSeries, setAskEditSeries] = useState<boolean>();
    const [askDeleteSeries, setAskDeleteSeries] = useState<boolean>(false);
    const [selectedInstructurs, setSelectedInstructurs] = useState<Instructor[]>([]);
    const {canEdit} = useAccount();
    const isEdit = !!currentValue ;
    const isSeries = currentValue?.repeat !== 0;

    useEffect(() => {
        if (!currentValue) {
            resetValues()
        } else {
            setStartDate(moment(currentValue.start))
            setEndDate(moment(currentValue.end))
            setSelectedCalendarId(currentValue.calendarId ?? calendarId)
            setLocation(currentValue.location)
            setDescription(currentValue.description ?? "")
            setSerieEnd(moment(currentValue.endSeries ?? moment()))
            setSerie(currentValue.repeat)
            setSelectedLectureId(currentValue.lecture.id!)
            setSelectedInstructurs(currentValue.instructors)
        }
    }, [currentValue])

    const resetValues = () => {
        setStartDate(moment())
        setEndDate(moment())
        setSerie(serialList[0].value);
        setLocation("")
        setDescription("")
        setSerieEnd(moment())
        setSelectedCalendarId(calendarId ?? "")
        setSelectedLectureId("")
    }

    const handleClose = () => {
        resetValues()
        onDialogClose()
    }

    const handleAddOrEditEvent = (editSeries: boolean | undefined = undefined) => {
        const base:CalendarEventBase={
            calendarId: selectedCalendarId,
            repeat: serie,
            description: description,
            instructors: selectedInstructurs,
            location: location,
            start: startDate,
            end: endDate,
        }
        if(currentValue) {
            if(onDialogEdit && editSeries) {
                const data: UpdateCalendarEventSeries = {
                    ...base,
                    ...currentValue,
                    endSeries: serieEnd,
                    lectureId: selectedLectureId,
                }
                onDialogEdit({
                    calendarId: currentValue.calendarId,
                    eventSeries: data,
                    event: undefined
                });
            } else if(onDialogEdit && !editSeries) {
                const data: UpdateCalendarEvent = {
                    ...base,
                    ...currentValue,
                    calendarId: currentValue.calendarId,
                    endSeries: serieEnd,
                    lectureId: selectedLectureId
                }
                onDialogEdit({
                    calendarId: currentValue.calendarId,
                    event: data,
                    eventSeries: undefined
                })
            }
        } else if(onDialogAdd) {
            const data: CreateCalendarEvent = {
                ...base,
                lectureId: selectedLectureId,
                description: description ?? undefined,
                endSeries: serieEnd ?? undefined,
            }
            onDialogAdd(data);
        }

        handleClose()
    }
    const validateRequiredFilds = (): boolean => {
        return selectedCalendarId?.length > 0 &&
            selectedLectureId?.length > 0 &&
            location?.length > 0 &&
            selectedInstructurs?.length > 0;
    }
    const validateTimeFilds = (): boolean => {
        let isValidSerie = true;
        if(serie !== serialList[0].value) {
            isValidSerie = !!serieEnd;
        }
        return startDate &&
            endDate &&
            endDate > startDate &&
            isValidSerie;
    }
    const canClickAdd = () =>
        validateRequiredFilds() && validateTimeFilds()


    const deleteEventMutation = useMutation({
        mutationFn: async ({calendarId, event}: { calendarId: string, event: CalendarEvent }) => {
            const result = await deleteEvent(calendarId, event)
            onDeletedEvent(event)
            return result;
        },
        onSuccess: (_) => {
            handleClose()
        },
    })
    const deleteEventSeriesMutation = useMutation({
        mutationFn: async ({calendarId, event}: { calendarId: string, event: CalendarEvent }) => {
            const result = await deleteEventSeries(calendarId, event.seriesId)
            onDeletedEvent(event)
            return result;
        },
        onSuccess: (_) => {
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

    const addOrEditContent = (disabled: boolean) => {
        const requiredFields = (disabled: boolean) => {
            return (
                <Stack direction="column" spacing={2} sx={{margin: 1, mt: 2}}>
                    <CalendarSelect disabled={disabled || isEdit}
                                    readonlyValue={currentValue?.calendar?.name}
                                    value={selectedCalendarId}
                                    onChange={setSelectedCalendarId}/>
                    <LectureSelect disabled={disabled}
                                   readonlyValue={currentValue?.lecture?.title}
                                   value={selectedLectureId}
                                   onChange={setSelectedLectureId}/>
                    <TextField disabled={disabled}
                               margin="dense"
                               label="Vorlesungsort"
                               type="text"
                               value={location}
                               onChange={(e) => setLocation(e.target.value)}
                    />
                    <InstructorSelect value={selectedInstructurs} onChange={setSelectedInstructurs}/>
                </Stack>)
        }

        const timeFields = (disabled: boolean) => {
            return (
                <Stack spacing={2} sx={{margin: 1}}>
                    <Stack direction="row" spacing={2} sx={{mt: 1, mb: 1}}>
                        <DateTimePicker disabled={disabled}
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
                            disabled={disabled}
                            onChange={(e) => setEndDate(e!)}
                            label="Ende"
                            viewRenderers={{
                                hours: renderTimeViewClock,
                                minutes: renderTimeViewClock,
                                seconds: renderTimeViewClock,
                            }}
                        />
                    </Stack>
                    {seriesFields(disabled)}
                </Stack>)
        }
        const seriesFields = (disabled: boolean) => {
            const shouldRender = !isEdit || isSeries;
            return shouldRender && (
                <Stack direction="row" spacing={1}>
                    <TextField disabled={disabled || isEdit}
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
                        disabled={serie === serialList[0].value || disabled}
                        value={serieEnd}
                        onChange={(e) => setSerieEnd(e!)}
                    />
                </Stack>
            )
        }

        const optionalFields = (disabled: boolean) => {
            return (<Stack spacing={2} sx={{margin: 1}}>
                <TextField disabled={disabled}
                           multiline
                           margin="dense"
                           type="text"
                           label="Zusätzlicher Kommentar"
                           maxRows={4}
                           value={description}
                           onChange={(e) => setDescription(e.target.value)}
                />
            </Stack>)
        }

        const layoutElement: LayoutDisplayItem[] = [
            {lable: "Allgemein", required: true, renderComponent: requiredFields(disabled), key: "required",errorFn:()=>!validateRequiredFilds(),errorMassage:"Fehlende Angaben"},
            {lable: "Zeit", required: true, renderComponent: timeFields(disabled), key: "time", errorFn:()=>!validateTimeFilds(),errorMassage:"Falsche Zeitangaben"},
            {lable: "Zusätzliche Infos", required: true, renderComponent: optionalFields(disabled), key: "optional"}
        ]

        return (
            <>
                <DialogTitle>
                    Event {isEdit ? "bearbeiten" : "hinzufügen"}
                </DialogTitle>
                <DialogContent sx={{width: '500px'}}>
                    {isEdit ?
                        <AccordionLayout
                            sections={layoutElement}
                            onCancel={onDialogClose}
                            canUpdate={canClickAdd()}
                            onDelete={() => {
                                if(isSeries) {
                                    setAskDeleteSeries(true)
                                } else {
                                    handleDeleteClick(false)
                                }
                            }}
                            onUpdate={() => isSeries ? setAskEditSeries(true) : handleAddOrEditEvent()}
                        /> : <StepperLayout
                            steps={layoutElement}
                            onCancel={handleClose}
                            onSubmit={() => handleAddOrEditEvent()}/>}
                </DialogContent>
            </>
        )
    }

    return (
        <Dialog open={isDialogOpen} onClose={handleClose}>
            {askEditSeries && <EditSeriesDialogContent
                title="Serie bearbeiten?"
                onCanceled={handleCancelAskDialog}
                onAccepted={handleAddOrEditEvent}>
                <Typography>
                    Wollen Sie nur das aktuelle Ereignis oder die gesamte Serie bearbeiten?
                </Typography>
            </EditSeriesDialogContent>}
            {askDeleteSeries && <EditSeriesDialogContent
                title="Serie löschen?"
                onCanceled={handleCancelAskDialog}
                onAccepted={handleDeleteClick}>
                <Typography>
                    Wollen Sie nur das aktuelle Ereignis oder die gesamte Serie löschen?
                </Typography>
            </EditSeriesDialogContent>}
            {!askEditSeries && !askDeleteSeries && addOrEditContent(!canEdit)}
        </Dialog>
    )
}
