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
import { Lecture } from '../../../models/lecture'

interface Props {
    isDialogOpen: boolean
    handleDialogAbort?: () => void
    handleDialogAdd?:(lecture:Lecture) => void
    handleDialogEdit?:(lecture:Lecture) => void
    currentLecture: Lecture | null
}

export const LectureDialog:FC<Props> = ({ isDialogOpen, handleDialogAbort, handleDialogAdd, handleDialogEdit, currentLecture}) => {
    console.log("lecture ", currentLecture);
    const [title, setTitle]=useState("");
    const [dozent, setDozent]=useState("");
    const [comments, setComments]=useState("");

    useEffect(() => {
        setTitle(currentLecture?.title??"")
        setDozent(currentLecture?.professor??"")
        setComments(currentLecture?.comment??"")
    }, [currentLecture])

    return (
        <Dialog open={isDialogOpen} onClose={handleDialogAbort}>
            <DialogTitle>Vorlesung {currentLecture==null? "hinzufügen":"bearbeiten"}</DialogTitle>
            <DialogContent sx={{ width: '500px' }}>
                <Stack>
                    <TextField
                        margin="dense"
                        id="name"
                        type="text"
                        label="Name"
                        value={title}
                        onChange={(e)=>setTitle(e.target.value)}
                    />
                    <TextField
                        margin="dense"
                        id="dozent"
                        label="Dozent"
                        type="text"
                        value={dozent}
                        onChange={(e)=>setDozent(e.target.value)}
                    />
                    <TextField
                        multiline
                        margin="dense"
                        id="comment"
                        type="text"
                        label="Zusätzliche Infos"
                        maxRows={4}
                        value={comments}
                        onChange={(e)=>setComments(e.target.value)}
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={handleDialogAbort}>Abbrechen</Button>
                <Button onClick={() => {
                    const l:Lecture ={title:""};
                    
                    if (currentLecture==null && handleDialogAdd)
                        handleDialogAdd(l)
                    else if (handleDialogEdit)
                        handleDialogEdit(l)
                }}>{currentLecture==null? "Hinzufügen":"Bearbeiten"}</Button>
            </DialogActions>
        </Dialog>
    )
}
