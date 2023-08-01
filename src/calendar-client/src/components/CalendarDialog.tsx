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
import { Calendar } from '../models/calendar'

interface Props {
    isDialogOpen: boolean
    handleDialogAbort?: () => void
    handleDialogAdd?:(calendar:Calendar) => void
    handleDialogEdit?:(calendar:Calendar) => void
    currentCalendar: Calendar | null
}

export const CalendarDialog:FC<Props> = ({ isDialogOpen, handleDialogAbort, handleDialogAdd, handleDialogEdit, currentCalendar}) => {
    console.log("lecture ", currentCalendar);
    const [name, setName]=useState("");
    const [startDate, setStartDate]=useState("");

    useEffect(() => {
        setName(currentCalendar?.name??"")
        setStartDate(currentCalendar?.startDate?.toString()??"")
    }, [currentCalendar])

    return (
        <Dialog open={isDialogOpen} onClose={handleDialogAbort}>
            <DialogTitle>Kalender {currentCalendar==null? "hinzufügen":"bearbeiten"}</DialogTitle>
            <DialogContent sx={{ width: '500px' }}>
                <Stack>
                    <TextField
                        margin="dense"
                        id="name"
                        type="text"
                        label="Name"
                        value={name}
                        onChange={(e)=>setName(e.target.value)}
                    />
                    <TextField
                        margin="dense"
                        id="startDate"
                        label="Startdatum"
                        type="text"
                        value={startDate}
                        onChange={(e)=>setStartDate(e.target.value)}
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={handleDialogAbort}>Abbrechen</Button>
                <Button onClick={() => {
                    const c:Calendar ={name:"", startDate:new Date()};
                    
                    if (currentCalendar==null && handleDialogAdd)
                        handleDialogAdd(c)
                    else if (handleDialogEdit)
                        handleDialogEdit(c)
                }}>{currentCalendar==null? "Hinzufügen":"Bearbeiten"}</Button>
            </DialogActions>
        </Dialog>
    )
}
