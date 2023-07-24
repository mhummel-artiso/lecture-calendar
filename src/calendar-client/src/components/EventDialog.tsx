import {
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    Stack,
    TextField,
} from '@mui/material'
import React from 'react'

interface Props {
    isDialogOpen: boolean
    handleDialogClose: () => void
}
export const EventDialog = ({ isDialogOpen, handleDialogClose }: Props) => {
    return (
        <Dialog open={isDialogOpen} onClose={handleDialogClose}>
            <DialogTitle>Detailansicht</DialogTitle>
            <DialogContent sx={{ width: '500px' }}>
                <Stack>
                    <TextField
                        margin="normal"
                        id="name"
                        label="Titel"
                        type="text"
                    />
                    <TextField
                        margin="normal"
                        id="name"
                        label="Ort"
                        type="text"
                    />
                    <TextField
                        margin="normal"
                        id="dozent"
                        label="Dozent"
                        type="text"
                        value={'Gude'}
                    />
                    <TextField
                        multiline
                        margin="normal"
                        id="comment"
                        label="Infos"
                        type="text"
                        maxRows={4}
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={handleDialogClose}>Cancel</Button>
                <Button onClick={() => console.log('')}>Subscribe</Button>
            </DialogActions>
        </Dialog>
    )
}
