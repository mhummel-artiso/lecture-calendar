import {
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    Stack,
    TextField,
} from '@mui/material'
import React, { useState } from 'react';

interface Props {
    isDialogOpen: boolean
    handleDialogClose: () => void
}

export const LectureDialog = ({ isDialogOpen, handleDialogClose }: Props) => {
    return (
        <Dialog open={isDialogOpen} onClose={handleDialogClose}>
            <DialogTitle>Lecture hinzufügen</DialogTitle>
            <DialogContent sx={{ width: '500px' }}>
                <Stack>
                    <TextField
                        margin="dense"
                        id="name"
                        type="text"
                        label="Name"
                    />
                    <TextField
                        margin="dense"
                        id="dozent"
                        label="Dozent"
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
