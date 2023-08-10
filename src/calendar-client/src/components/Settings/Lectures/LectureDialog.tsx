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

export const LectureDialog: FC<DialogComponentProps<Lecture, Lecture, Lecture>> = ({
                                                                     isDialogOpen,
                                                                     onDialogClose,
                                                                     onDialogAdd,
                                                                     onDialogEdit,
                                                                     currentValue: currentLecture
                                                                 }) => {
    const [title, setTitle] = useState<string>("");
    const [dozent, setDozent] = useState<string>("");
    const [comments, setComments] = useState<string>("");

    useEffect(() => {
        setTitle(currentLecture?.title ?? "")
        setDozent(currentLecture?.professor ?? "")
        setComments(currentLecture?.comment ?? "")
    }, [currentLecture])

    const canAddOrEdit = (): boolean => !!title && !!dozent

    const handleSubmitClick = () => {
        const l: Lecture = {id: currentLecture?.id, title: title, professor: dozent, comment: comments};
        if(currentLecture == null && onDialogAdd) {
            onDialogAdd(l)
        } else if(onDialogEdit) {
            onDialogEdit(l)
        }
        onDialogClose()
    }
    return (
        <Dialog open={isDialogOpen} onClose={onDialogClose}>
            <DialogTitle>Vorlesung {currentLecture == null ? "hinzufügen" : "bearbeiten"}</DialogTitle>
            <DialogContent sx={{width: '500px'}}>
                <Stack>
                    <TextField
                        margin="dense"
                        id="name"
                        type="text"
                        label="Name"
                        value={title}
                        required
                        onChange={(e) => setTitle(e.target.value)}
                    />
                    <TextField
                        margin="dense"
                        id="dozent"
                        label="Dozent"
                        type="text"
                        required
                        value={dozent}
                        onChange={(e) => setDozent(e.target.value)}
                    />
                    <TextField
                        multiline
                        margin="dense"
                        id="comment"
                        type="text"
                        label="Zusätzliche Informationen"
                        maxRows={4}
                        value={comments}
                        onChange={(e) => setComments(e.target.value)}
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={onDialogClose}>Abbrechen</Button>
                <Button disabled={!canAddOrEdit()}
                        onClick={handleSubmitClick}>{currentLecture == null ? "Hinzufügen" : "Bearbeiten"}</Button>
            </DialogActions>
        </Dialog>
    )
}
