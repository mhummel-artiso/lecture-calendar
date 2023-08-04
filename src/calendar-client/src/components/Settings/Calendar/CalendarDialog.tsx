import {
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    Stack,
    TextField,
} from '@mui/material'
import React, { FC, useEffect, useState } from 'react'
import { Calendar } from '../../../models/calendar'
import { DatePicker } from "@mui/x-date-pickers/DatePicker";
import { Moment } from "moment/moment"
import moment from "moment";
import { DialogComponentProps } from "../../../models/dialogComponentProps";

interface Props {
    isDialogOpen: boolean
    handleDialogAbort?: () => void
    handleDialogAdd?: (calendar: Calendar) => void
    handleDialogEdit?: (calendar: Calendar) => void
    currentCalendar: Calendar | null | undefined
}

export const CalendarDialog: FC<DialogComponentProps<Calendar>> = ({
                                                                       isDialogOpen,
                                                                       handleDialogAbort,
                                                                       handleDialogAdd,
                                                                       handleDialogEdit,
                                                                       currentValue: currentCalendar
                                                                   }) => {
    const [name, setName] = useState<string | null>(null);
    const [startDate, setStartDate] = useState<Moment | null>(null);

    useEffect(() => {
        console.log("currentCalendar", currentCalendar)
        setName(currentCalendar?.name ?? "")
        const str = moment(currentCalendar?.startDate)
        setStartDate(str)
    }, [currentCalendar])

    const canAddOrEdit = (): boolean => !!name && !!startDate

    const handleSubmitClick = () => {
        const c: Calendar = {name: name!, startDate: moment(startDate)};
        if(currentCalendar == null && handleDialogAdd) {
            handleDialogAdd(c)
        } else if(handleDialogEdit) {
            handleDialogEdit(c)
        }
    }
    return (
        <Dialog open={isDialogOpen} onClose={handleDialogAbort}>
            <DialogTitle>Kalender {currentCalendar == null ? "hinzufügen" : "bearbeiten"}</DialogTitle>
            <DialogContent sx={{width: '500px'}}>
                <Stack>
                    <TextField
                        margin="dense"
                        id="name"
                        type="text"
                        label="Name"
                        value={name}
                        required
                        onChange={(e) => setName(e.target.value)}
                    />
                    <DatePicker
                        sx={{mt: 2}}
                        label="Startdatum"
                        value={startDate}
                        onChange={(e) => setStartDate(e)}
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={handleDialogAbort}>Abbrechen</Button>
                <Button disabled={!canAddOrEdit()}
                        onClick={handleSubmitClick}>{currentCalendar == null ? "Hinzufügen" : "Bearbeiten"}</Button>
            </DialogActions>
        </Dialog>
    )
}
