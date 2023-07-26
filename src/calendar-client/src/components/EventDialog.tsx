import {
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    MenuItem,
    Stack,
    TextField,
    Switch,
    FormControlLabel,
    Checkbox,
} from '@mui/material'
import React, { useState } from 'react';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { TimePicker } from '@mui/x-date-pickers/TimePicker';

interface Props {
    isDialogOpen: boolean
    handleDialogClose: () => void
}

export const EventDialog = ({ isDialogOpen, handleDialogClose }: Props) => {
    const [course, setCourse] = React.useState('tin21') // Change to use course that Person is currently on its calendar
    const [lecture, setLecture] = React.useState('')
    const [courseList, setCourseList] = React.useState([
        { id: 1, value: 'tin20', label: 'TIN20' },
        { id: 2, value: 'tin21', label: 'TIN21' },
        { id: 3, value: 'tin22', label: 'TIN22' },
    ])
    const [lectureList, setLectureList] = React.useState([
        { id: 1, value: "mathe", label: "Mathematik" },
        { id: 2, value: "compilerbau", label: "Compilerbau" },
        { id: 3, value: "datenbanken", label: "Datenbanken" },
    ]);
    const [serialList, setSerialList] = React.useState([
        { id: 1, value: "dnr", label: "Einzeltermin" },
        { id: 2, value: "weekly", label: "Wöchentlich wiederholen" },
        { id: 3, value: "monthly", label: "Monatlich wiederholen" },
    ]);
    const [selectedValue, setSelectedValue] = useState(serialList[0].value);

    const handleSelectChange = (event: { target: { value: React.SetStateAction<string>; }; }) => {
        setSelectedValue(event.target.value);
    };


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
                    <Stack direction="row" spacing={2} sx={{mt: 1, mb: 1}}>
                        <DatePicker label="Tag"/>
                        <TimePicker label="Beginn"/>
                        <TimePicker label="Ende"/>
                    </Stack>
                    <Stack direction="row" >
                        <TextField
                            margin="dense"
                            select 
                            fullWidth
                            defaultValue={serialList[0].value}
                            value={selectedValue}
                            onChange={handleSelectChange}
                            >
                            {serialList.map((item) => (
                                <MenuItem key={item.id} value={item.value}>
                                {item.label}
                                </MenuItem>
                            ))}
                        </TextField>
                        <DatePicker label="Serienende" sx={{ml:2, mt: 1, mb: 1}} disabled={selectedValue===serialList[0].value}/>
                    </Stack>
                    <TextField
                        margin="dense"
                        id="dozent"
                        type="text"
                        label="Dozent"
                    />
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
