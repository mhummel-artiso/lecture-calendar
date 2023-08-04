import {
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    Stack,
    TextField,
} from '@mui/material'
import * as dayjs from 'dayjs'
import React, { FC, useEffect, useState } from 'react'
import { Calendar } from '../../../models/calendar'
import { DatePicker } from "@mui/x-date-pickers/DatePicker";
import { Dayjs } from "dayjs";

interface Props {
    isDialogOpen: boolean
    handleDialogAbort?: () => void
    handleDialogAdd?: (calendar: Calendar) => void
    handleDialogEdit?: (calendar: Calendar) => void
    currentCalendar: Calendar | null
}

export const CalendarDialog: FC<Props> = ({
                                              isDialogOpen,
                                              handleDialogAbort,
                                              handleDialogAdd,
                                              handleDialogEdit,
                                              currentCalendar
                                          }) => {
    const [name, setName] = useState<string | null>(null);
    const [startDate, setStartDate] = useState<Dayjs | null>(null);

    useEffect(() => {
        console.log("currentCalendar", currentCalendar)
        setName(currentCalendar?.name ?? "")
        const str = dayjs(currentCalendar?.startDate)
        setStartDate(str)
    }, [currentCalendar])

    const canAddOrEdit = (): boolean => !!name && !!startDate

    const handleSubmitClick = () => {
        const c: Calendar = {name: name!, startDate: dayjs(startDate)};
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
