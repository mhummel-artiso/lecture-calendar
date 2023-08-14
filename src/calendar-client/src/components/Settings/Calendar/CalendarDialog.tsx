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

export const CalendarDialog: FC<DialogComponentProps<Calendar, Calendar, Calendar>> = ({
                                                                                           isDialogOpen,
                                                                                           onDialogClose,
                                                                                           onDialogAdd,
                                                                                           onDialogEdit,
                                                                                           currentValue: currentCalendar
                                                                                       }) => {
    const [name, setName] = useState<string>("");
    const [startDate, setStartDate] = useState<Moment | null>(moment());

    useEffect(() => {
        setName(currentCalendar?.name ?? "")
        setStartDate(moment(currentCalendar?.startDate))
    }, [currentCalendar])

    const canAddOrEdit = (): boolean => !!name && !!startDate

    const handleSubmitClick = () => {
        const c: Calendar = {id: currentCalendar?.id, name: name, startDate: moment(startDate)};
        if(currentCalendar == null && onDialogAdd) {
            onDialogAdd(c)
        } else if(onDialogEdit) {
            onDialogEdit(c)
        }
        onDialogClose()
    }
    return (
        <Dialog open={isDialogOpen} onClose={onDialogClose}>
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
                <Button onClick={onDialogClose}>Abbrechen</Button>
                <Button disabled={!canAddOrEdit()}
                        onClick={handleSubmitClick}>{currentCalendar == null ? "Hinzufügen" : "Bearbeiten"}</Button>
            </DialogActions>
        </Dialog>
    )
}
