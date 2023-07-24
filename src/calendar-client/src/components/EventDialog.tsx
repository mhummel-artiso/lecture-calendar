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
    const [courseList, setCourseList] = React.useState([
        { id: 1, value: "tin20", label: "TIN20" },
        { id: 2, value: "tin21", label: "TIN21" },
        { id: 3, value: "tin22", label: "TIN22" },
    ]);
    const [lectureList, setLectureList] = React.useState([
        { id: 1, value: "mathe", label: "Mathematik" },
        { id: 2, value: "compilerbau", label: "Compilerbau" },
        { id: 3, value: "datenbanken", label: "Datenbanken" },
    ]);

    return (
        <Dialog open={isDialogOpen} onClose={handleDialogClose}>
            <DialogTitle>Event hinzufügen</DialogTitle>
            <DialogContent sx={{ width: '500px' }}>
                <Stack>
                    {/* TODO: API Daten fetchen */}
                    <TextField
                        margin="dense"
                        value={course}
                        onChange={(e) => setCourse(e.target.value)}
                        select 
                        label="Kurs"
                        >
                        {courseList.map((item) => (
                            <MenuItem key={item.id} value={item.value}>
                            {item.label}
                            </MenuItem>
                        ))}
                    </TextField>
                    <TextField
                        margin="dense"
                        value={lecture}
                        onChange={(e) => setLecture(e.target.value)}
                        select 
                        label="Vorlesung"
                        >
                        {lectureList.map((item) => (
                            <MenuItem key={item.id} value={item.value}>
                            {item.label}
                            </MenuItem>
                        ))}
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
