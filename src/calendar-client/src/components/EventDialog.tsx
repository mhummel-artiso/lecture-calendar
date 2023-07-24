import {
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    MenuItem,
    Stack,
    TextField,
} from '@mui/material'
import React, { useState } from 'react'
import { DateTimePicker } from '@mui/x-date-pickers/DateTimePicker';

interface Props {
    isDialogOpen: boolean
    handleDialogClose: () => void
}

export const EventDialog = ({ isDialogOpen, handleDialogClose }: Props) => {
    const [course, setCourse] = React.useState('tin21');                // Change to use course that Person is currently on its calendar
    const [lecture, setLecture] = React.useState('');

    return (
        <Dialog open={isDialogOpen} onClose={handleDialogClose}>
            <DialogTitle>Event hinzufügen</DialogTitle>
            <DialogContent sx={{ width: '500px' }}>
                <Stack>
                    {/* TODO: API Daten fetchen */}
                    <TextField
                        margin="dense"
                        defaultValue={"tin20"}
                        value={course}
                        onChange={(e) => setCourse(e.target.value)}
                        select 
                        label="Kurs"
                        >
                        <MenuItem key={1} value="tin20">TIN20</MenuItem>
                        <MenuItem key={2} value="tin21">TIN21</MenuItem>
                        <MenuItem key={3} value="tin22">TIN22</MenuItem>
                    </TextField>
                    <TextField
                        margin="dense"
                        defaultValue={"Mathe"}
                        value={lecture}
                        onChange={(e) => setLecture(e.target.value)}
                        select 
                        label="Vorlesung"
                        >
                        <MenuItem key={1} value="mathe">Mathematik</MenuItem>
                        <MenuItem key={2} value="compilerbau">Compilerbau</MenuItem>
                        <MenuItem key={3} value="datenbanken">Datenbanken</MenuItem>
                    </TextField>
                    <TextField
                        margin="dense"
                        id="dozent"
                        type="text"
                        label="Dozent"
                    />
                    <DateTimePicker label="Vorlesungsbeginn" sx={{mt:1, mb: 1}}/>
                    <DateTimePicker label="Vorlesungsende" sx={{mt:1, mb: 1}}/>
                    <TextField
                        margin="dense"
                        id="name"
                        label="Vorlesungsort"
                        type="text"
                    />
                    <TextField
                        multiline
                        margin="dense"
                        id="comment"
                        type="text"
                        label="Zusätzliche Infos"
                        maxRows={4}
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={handleDialogClose}>Abbrechen</Button>
                <Button onClick={() => console.log('')}>Hinzufügen</Button>
            </DialogActions>
        </Dialog>
    )
}
