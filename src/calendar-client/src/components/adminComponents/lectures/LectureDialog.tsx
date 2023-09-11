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
import { DialogComponentProps } from '../../../models/dialogComponentProps'

export const LectureDialog: FC<
    DialogComponentProps<Lecture, Lecture, Lecture>
> = ({
    isDialogOpen,
    onDialogClose,
    onDialogAdd,
    onDialogEdit,
    currentValue: currentLecture,
}) => {
    const [title, setTitle] = useState<string>('')
    const [shortKey, setShortKey] = useState<string>('')
    const [description, setDescription] = useState<string>('')

    useEffect(() => {
        setTitle(currentLecture?.title ?? '')
        setShortKey(currentLecture?.shortKey ?? '')
        setDescription(currentLecture?.description ?? '')
    }, [currentLecture, isDialogOpen])

    const canAddOrEdit = (): boolean => !!title

    const handleSubmitClick = () => {
        const l: Lecture = {
            id: currentLecture?.id,
            title,
            shortKey,
            description,
        }
        if (currentLecture == null && onDialogAdd) {
            onDialogAdd(l)
        } else if (onDialogEdit) {
            onDialogEdit(l)
        }
        onDialogClose()
    }
    return (
        <Dialog open={isDialogOpen} onClose={onDialogClose}>
            <DialogTitle>
                Vorlesung {currentLecture == null ? 'hinzufügen' : 'bearbeiten'}
            </DialogTitle>
            <DialogContent sx={{ width: '500px' }}>
                <Stack>
                    <TextField
                        margin="dense"
                        id="kursname"
                        type="text"
                        label="Kurs Name"
                        value={title}
                        required
                        onChange={(e) => setTitle(e.target.value)}
                    />
                    <TextField
                        margin="dense"
                        id="shortKey"
                        label="Kurs Kürzel"
                        type="text"
                        value={shortKey}
                        onChange={(e) => setShortKey(e.target.value)}
                    />
                    <TextField
                        multiline
                        margin="dense"
                        id="kursdescription"
                        type="text"
                        label="Kurs beschreibung"
                        minRows={2}
                        maxRows={4}
                        value={description}
                        onChange={(e) => setDescription(e.target.value)}
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={onDialogClose}>Abbrechen</Button>
                <Button disabled={!canAddOrEdit()} onClick={handleSubmitClick}>
                    {currentLecture == null ? 'Hinzufügen' : 'Bearbeiten'}
                </Button>
            </DialogActions>
        </Dialog>
    )
}
