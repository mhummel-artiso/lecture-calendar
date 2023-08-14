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
    CalendarEvent,
    CreateCalendarEvent,
    UpdateCalendarEvent,
    UpdateCalendarEventSeries
} from '../../models/calendarEvent'
import { Moment } from "moment/moment";
import moment from "moment";
import { deleteEvent, deleteEventSeries } from "../../services/CalendarService";
import { DialogComponentProps } from "../../models/dialogComponentProps";
import DeleteIcon from '@mui/icons-material/Delete'
import { Instructor } from '../../models/instructor'
import { LectureSelect } from './LectureSelect'
import { CalendarSelect } from './CalendarSelect'
import { InstructorSelect } from './InstructorSelect'
import { EditSeriesDialogContent } from './EditSeriesDialogContent'
import { renderTimeViewClock } from '@mui/x-date-pickers/timeViewRenderers';
import { useAccount } from '../../hooks/useAccount'

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

type TextFieldViewType = 'required' | 'time' | 'optional';
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
    const [comment, setComment] = useState<string>("");
    const [serieEnd, setSerieEnd] = useState<Moment>(moment());
    const [serie, setSerie] = useState<number>(serialList[0].value);
    const [askEditSeries, setAskEditSeries] = useState<boolean>();
    const [askDeleteSeries, setAskDeleteSeries] = useState<boolean>(false);
    const [selectedInstructurs, setSelectedInstructurs] = useState<Instructor[]>([]);
    const {canEdit} = useAccount();

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
            setSelectedInstructurs(currentValue.instructors)
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
                    instructors: currentValue.instructors,
                    lastUpdateDate: currentValue.lastUpdateDate,
                    createdDate: currentValue.createdDate,
                    end: endDate,
                    start: startDate,
                    description: comment,
                    repeat: serie,
                    endSeries: serieEnd,
                    location: location,
                    lectureId: selectedLectureId,
                    seriesId: currentValue.seriesId,
                    calendarId: currentValue.calendarId
                }
                onDialogEdit({
                    calendarId: currentValue.calendarId,
                    eventSeries: data,
                    event: undefined
                });
            } else if(onDialogEdit && !editSeries) {
                const data: UpdateCalendarEvent = {
                    calendarId: currentValue.calendarId,
                    createdDate: currentValue.createdDate,

                    id: currentValue.id,
                    // TODO add ui for instructors
                    instructors: currentValue.instructors,
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
                    calendarId: currentValue.calendarId,
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
                instructors: selectedInstructurs
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
        if(serie != serialList[0].value) {
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


    const addOrEditContent = () => {
        const requiredFields = () => {
            const {canEdit} = useAccount();
            return (<Stack direction="column" spacing={2} sx={{margin: 1, mt: 2}}>
                <CalendarSelect readonlyValue={currentValue?.calendar?.name} value={selectedCalendarId}
                                onChange={setSelectedCalendarId}/>
                <LectureSelect readonlyValue={currentValue?.lecture?.title} value={selectedLectureId}
                               onChange={setSelectedLectureId}/>
                <TextField disabled={!canEdit}
                           margin="dense"
                           label="Vorlesungsort"
                           type="text"
                           value={location}
                           onChange={(e) => setLocation(e.target.value)}
                />
                <InstructorSelect value={selectedInstructurs} onChange={setSelectedInstructurs}/>
            </Stack>)
        }

        const timeFields = () => {
            return (
                <Stack spacing={2} sx={{margin: 1}}>
                    <Stack direction="row" spacing={2} sx={{mt: 1, mb: 1}}>
                        <DateTimePicker disabled={!canEdit}
                                        key={"start"}
                                        value={startDate}
                                        onChange={value => {
                                            setStartDate(value!)
                                            setEndDate(value!)
                                        }}
                                        label="Start"
                        />
                        <TimePicker
                            value={endDate} disabled={!canEdit}
                            onChange={(e) => setEndDate(e!)}
                            label="Ende"
                            viewRenderers={{
                                hours: renderTimeViewClock,
                                minutes: renderTimeViewClock,
                                seconds: renderTimeViewClock,
                            }}
                        />
                    </Stack>
                    {seriesFields()}
                </Stack>)
        }
        const seriesFields = () => {
            const shouldRender = !currentValue || currentValue.seriesId;
            console.log('shouldRender', shouldRender);
            return shouldRender && (
                <Stack direction="row">
                    <TextField disabled={!canEdit}
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
                        disabled={serie === serialList[0].value || !canEdit}
                        value={serieEnd}
                        onChange={(e) => setSerieEnd(e!)}
                    />
                </Stack>
            )

        }
        const optionalFields = () => {
            return (<Stack spacing={2} sx={{margin: 1}}>
                <TextField disabled={!canEdit}
                           multiline
                           margin="dense"
                           type="text"
                           label="zusätzlicher Kommentar"
                           maxRows={4}
                           value={comment}
                           onChange={(e) => setComment(e.target.value)}
                />
            </Stack>)
        }
        const accordionLayout = () => {
            const [expanded, setExpanded] = React.useState<TextFieldViewType | boolean>('required');
            const handleChange = (panel: TextFieldViewType) => (event: React.SyntheticEvent, isExpanded: boolean) => {
                setExpanded(isExpanded ? panel : false);
            }
            return (
                <>
                    <Accordion onChange={handleChange("required")} expanded={expanded == "required"}>
                        <AccordionSummary expandIcon={<ExpandMoreIcon/>}>
                            <Typography>Allgemein</Typography>
                        </AccordionSummary>
                        <AccordionDetails>
                            {requiredFields()}
                        </AccordionDetails>
                    </Accordion>
                    <Accordion onChange={handleChange("time")} expanded={expanded == "time"}>
                        <AccordionSummary expandIcon={<ExpandMoreIcon/>}>
                            <Typography>Zeit</Typography>
                        </AccordionSummary>
                        <AccordionDetails>
                            {timeFields()}
                        </AccordionDetails>
                    </Accordion>
                    <Accordion onChange={handleChange("optional")} expanded={expanded == "optional"}>
                        <AccordionSummary expandIcon={<ExpandMoreIcon/>}>
                            <Typography>Zusätzliche Infos</Typography>
                        </AccordionSummary>
                        <AccordionDetails>
                            {optionalFields()}
                        </AccordionDetails>
                    </Accordion>
                </>
            )
        }
        const stepperLayout = () => {
            console.log('setepperLayout');
            const steps = [
                {lable: "Allgemein", required: true},
                {lable: "Zeit", required: true},
                {lable: "Zusätzliche Infos", required: true}]
            const [activeStep, setActiveStep] = React.useState(0);
            const [completed, setCompleted] = React.useState<{
                [k: number]: boolean;
            }>({});

            const handleStep = (step: number) => () => {
                setActiveStep(step);
                const newCompleted = completed;
                for(let i = steps.length - 1; i >= step; i--) {
                    newCompleted[i] = false
                }
                setCompleted(newCompleted)
            }
            const totalSteps = () => {
                return steps.length;
            };

            const isLastStep = () => {
                return activeStep === totalSteps() - 1;
            };
            const handleComplete = () => {
                const newCompleted = completed;
                setCompleted(prevState => {
                    newCompleted[activeStep] = true
                    return newCompleted
                });
                setActiveStep((prevActiveStep) => prevActiveStep + 1)
            }
            const singelStep = (x: { lable: string, required: boolean }, index: number) => {
                const lableProps: {
                    optional?: React.ReactNode;
                    error?: boolean;
                } = {};
                if(activeStep !== index) {
                    switch(index) {
                        case 0:
                            lableProps.error = !validateRequiredFilds();
                            if(lableProps.error) {
                                lableProps.optional = (
                                    <Typography variant="caption" color="error">
                                        Fehlende Pflichtfelder
                                    </Typography>
                                )
                            }
                            break;
                        case 1:
                            lableProps.error = !validateTimeFilds();
                            if(lableProps.error) {
                                lableProps.optional = (
                                    <Typography variant="caption" color="error">
                                        Fehlende Zeitangaben
                                    </Typography>
                                )
                            }
                    }
                }

                return (
                    <Step key={x.lable} completed={completed[index]} color={completed[index] ? "success" : undefined}>
                        <StepLabel {...lableProps} onClick={handleStep(index)}>
                            {x.lable}
                        </StepLabel>
                    </Step>)
            }
            const canContinue = () => {
                switch(activeStep) {
                    case 0:
                        return validateRequiredFilds();
                    case 1:
                        return validateTimeFilds();
                    default:
                        return true;
                }
            }
            return (<>
                    <Stepper nonLinear activeStep={activeStep}>
                        {steps.map(singelStep)}
                    </Stepper>
                    {activeStep == 0 && requiredFields()}
                    {activeStep == 1 && timeFields()}
                    {activeStep == 2 && optionalFields()}
                    <Box sx={{flex: "1 1 auto"}}>
                        {isLastStep() ? (
                            <Button onClick={() => handleAddOrEditEvent()} disabled={!completed[0] && !completed[1]}
                                    variant="contained">
                                Hinzufügen
                            </Button>
                        ) : (<Button onClick={handleComplete} disabled={!canContinue()}>
                            Weiter
                        </Button>)}
                        <Button onClick={handleClose}>Abbrechen</Button>
                    </Box>
                </>
            )
        }

        return (
            <>
                <DialogTitle>
                    Event {currentValue ? "bearbeiten" : "hinzufügen"}
                </DialogTitle>
                <DialogContent sx={{width: '500px'}}>
                    {currentValue ? accordionLayout() : canEdit && stepperLayout()}
                </DialogContent>
                {currentValue &&
                    <DialogActions>
                        {canEdit &&
                            <IconButton edge="end"
                                        aria-label="delete"
                                        onClick={(e) => {
                                            e.stopPropagation();
                                            if(currentValue.seriesId !== undefined || currentValue?.seriesId !== null) {
                                                setAskDeleteSeries(true)
                                            } else {
                                                handleDeleteClick(false)
                                            }
                                        }}
                                        color="error"
                            >
                                <DeleteIcon/>
                            </IconButton>}
                        <Button
                            onClick={onDialogClose}>
                            {canEdit ? "Abbrechen" : "Schließen"}
                        </Button>
                        {canEdit &&
                            <Button
                                onClick={() => currentValue.seriesId ? setAskEditSeries(true) : handleAddOrEditEvent()}
                                disabled={!canClickAdd()} variant="contained">
                                Bearbeiten</Button>}
                    </DialogActions>
                }

            </>
        )
    }

    return (
        <Dialog open={isDialogOpen} onClose={handleClose}>
            {askEditSeries && <EditSeriesDialogContent
                title="Serie Bearbeiten?"
                onCanceled={handleCancelAskDialog}
                onAccepted={handleAddOrEditEvent}>
                <Typography>
                    Wollen sie nur das aktuelle Ereignis oder die gesamte Serie Bearbeiten?
                </Typography>
            </EditSeriesDialogContent>}
            {askDeleteSeries && <EditSeriesDialogContent
                title="Serie Löschen?"
                onCanceled={handleCancelAskDialog}
                onAccepted={handleDeleteClick}>
                <Typography>
                    Wollen sie nur das aktuelle Ereignis oder die gesamte Serie löschen?
                </Typography>
            </EditSeriesDialogContent>}
            {!askEditSeries && !askDeleteSeries && addOrEditContent()}
        </Dialog>
    )
}
