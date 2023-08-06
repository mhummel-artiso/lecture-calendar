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
import { DialogComponentProps } from "../../../models/dialogComponentProps";

export const LectureDialog: FC<DialogComponentProps<Lecture>> = ({
                                                                     isDialogOpen,
                                                                     handleDialogAbort,
                                                                     handleDialogAdd,
                                                                     handleDialogEdit,
                                                                     currentValue: currentLecture
                                                                 }) => {
    console.log("lecture ", currentLecture);
    const [title, setTitle] = useState("");
    const [dozent, setDozent] = useState("");
    const [comments, setComments] = useState("");

    useEffect(() => {
        setTitle(currentLecture?.title ?? "")
        setDozent(currentLecture?.professor ?? "")
        setComments(currentLecture?.comment ?? "")
    }, [currentLecture])
    
    const handleSubmitClick = () => {
        const l: Lecture = {title: title, professor: dozent, comment: comments};
        if(currentLecture == null && handleDialogAdd) {
            handleDialogAdd(l)
        } else if(handleDialogEdit) {
            handleDialogEdit(l)
        }
    }
    return (
        <Dialog open={isDialogOpen} onClose={handleDialogAbort}>
            <DialogTitle>Vorlesung {currentLecture == null ? "hinzufügen" : "bearbeiten"}</DialogTitle>
            <DialogContent sx={{width: '500px'}}>
                <Stack>
                    <TextField
                        margin="dense"
                        id="name"
                        type="text"
                        label="Name"
                        value={title}
                        onChange={(e) => setTitle(e.target.value)}
                    />
                    <TextField
                        margin="dense"
                        id="dozent"
                        label="Dozent"
                        type="text"
                        value={dozent}
                        onChange={(e) => setDozent(e.target.value)}
                    />
                    <TextField
                        multiline
                        margin="dense"
                        id="comment"
                        type="text"
                        label="Zusätzliche Infos"
                        maxRows={4}
                        value={comments}
                        onChange={(e) => setComments(e.target.value)}
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={handleDialogAbort}>Abbrechen</Button>
                <Button onClick={handleSubmitClick}>{currentLecture == null ? "Hinzufügen" : "Bearbeiten"}</Button>
            </DialogActions>
        </Dialog>
    )
}