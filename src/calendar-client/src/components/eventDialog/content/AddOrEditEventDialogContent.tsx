import {
    DialogContent,
    DialogTitle,
    MenuItem,
    Stack,
    TextField,
} from '@mui/material'
import { DatePicker } from '@mui/x-date-pickers/DatePicker'
import { DateTimePicker, TimePicker } from '@mui/x-date-pickers'
import { renderTimeViewClock } from '@mui/x-date-pickers/timeViewRenderers';
import { CalendarSelect } from "../selects/CalendarSelect";
import { LectureSelect } from "../selects/LectureSelect";
import { InstructorSelect } from "../selects/InstructorSelect";
import { LayoutDisplayItem } from "../DialogSelectInterfaces";
import { AccordionLayout } from "../layout/AccordionLayout";
import { StepperLayout } from "../layout/StepperLayout";
import { FC, useEffect, useState } from 'react';
import { useAccount } from '../../../hooks/useAccount';
import React from 'react';
import { Moment } from "moment/moment";
import moment from "moment";
import { Instructor } from '../../../models/instructor';
import { CalendarEvent } from '../../../models/calendarEvent';
import { Calendar } from "../../../models/calendar";
import { Lecture } from "../../../models/lecture";

const serialList = [
    {value: 0, label: 'Nicht wiederholen'},
    {value: 1, label: 'Täglich wiederholen'},
    {value: 2, label: 'Wöchentlich wiederholen'},
    {value: 3, label: 'Monatlich wiederholen'},
]

export interface PassedDialogValues {
    calendarId: string
    lectureId: string
    start: Moment
    end: Moment
    location: string
    description: string
    serieEnd: Moment
    repeat: number
    instructors: Instructor[]
}

interface Props {
    isEdit: boolean
    currentValue: CalendarEvent | null
    onDelete: () => void
    onAccept: (value: PassedDialogValues) => void
    onCancel: () => void
    calendarId: string
    isSeries: boolean
}

export const AddOrEditEventDialogContent: FC<Props> = (props) => {
    const {
        isEdit,
        currentValue,
        calendarId,
        isSeries,
        onCancel,
        onAccept,
        onDelete
    } = props;
    const {canEdit} = useAccount();

    const [selectedCalendarId, setSelectedCalendarId] = React.useState<string | null>(calendarId)
    const [selectedLectureId, setSelectedLectureId] = React.useState<string | null>("")
    const [startDate, setStartDate] = useState<Moment>(moment());
    const [endDate, setEndDate] = useState<Moment | undefined>();
    const [location, setLocation] = useState<string>("")
    const [description, setDescription] = useState<string>("");
    const [serieEnd, setSerieEnd] = useState<Moment>(moment());
    const [serie, setSerie] = useState<number>(serialList[0].value);
    const [selectedInstructors, setSelectedInstructors] = useState<Instructor[] | null>([]);


    useEffect(() => {
        if(!currentValue) {
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
            setSelectedInstructors(currentValue.instructors)
        }
    }, [currentValue, calendarId])

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
                           id="location"
                           type="text"
                           value={location}
                           onChange={(e) => setLocation(e.target.value)}
                />
                <InstructorSelect value={selectedInstructors} onChange={setSelectedInstructors}/>
            </Stack>)
    }

    const timeFields = (disabled: boolean) => {
        return (
            <Stack spacing={2}>
                <Stack direction="row" spacing={2}>
                    <DateTimePicker disabled={disabled}
                                    key={"start"}
                                    value={startDate}
                                    onChange={value => {
                                        setStartDate(value!)
                                        setEndDate(value!)
                                    }}
                                    label="Start"/>
                    <TimePicker
                        value={endDate}
                        disabled={disabled}
                        onChange={(e) => setEndDate(e!)}
                        label="Ende"
                        viewRenderers={{
                            hours: renderTimeViewClock,
                            minutes: renderTimeViewClock,
                            seconds: renderTimeViewClock,
                        }}/>
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

    const validateRequiredFields = (): boolean => {
        return (selectedCalendarId?.length ?? 0) > 0 &&
            (selectedLectureId?.length ?? 0) > 0 &&
            location?.length > 0 &&
            (selectedInstructors?.length ?? 0) > 0;
    }

    const validateTimeFields = (): boolean => {
        let isValidSerie = true;
        if(serie !== serialList[0].value) {
            isValidSerie = !!serieEnd;
        }
        return startDate &&
            !!endDate &&
            endDate > startDate &&
            isValidSerie;
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
        {
            lable: "Allgemein",
            required: true,
            renderComponent: requiredFields(!canEdit),
            key: "required",
            errorFn: () => !validateRequiredFields(),
            errorMassage: "Fehlende Angaben"
        },
        {
            lable: "Zeit",
            required: true,
            renderComponent: timeFields(!canEdit),
            key: "time",
            errorFn: () => !validateTimeFields(),
            errorMassage: "Falsche Zeitangaben"
        },
        {lable: "Zusätzliche Infos", required: true, renderComponent: optionalFields(!canEdit), key: "optional"}
    ]

    const handleCancel = () => {
        resetValues();
        onCancel();
    }

    const handleAccept = () => {
        onAccept({
            calendarId: selectedCalendarId!,
            lectureId: selectedLectureId!,
            start: startDate,
            end: endDate!,
            location,
            description,
            serieEnd,
            repeat: serie,
            instructors: selectedInstructors!
        });
    }

    const canClickAdd = () =>
        validateRequiredFields() && validateTimeFields()

    return (
        <>
            <DialogTitle>
                Event {isEdit ? "bearbeiten" : "hinzufügen"}
            </DialogTitle>
            <DialogContent sx={{width: '500px'}}>
                {isEdit ?
                    <AccordionLayout
                        sections={layoutElement}
                        onCancel={handleCancel}
                        canUpdate={canClickAdd()}
                        onDelete={onDelete}
                        onUpdate={handleAccept}
                    /> : <StepperLayout
                        steps={layoutElement}
                        onCancel={handleCancel}
                        onSubmit={handleAccept}/>}
            </DialogContent>
        </>
    )
}
