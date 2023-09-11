import {
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    Typography,
} from '@mui/material'
import React, { useEffect, useState } from 'react'
import { AxiosError } from 'axios'

interface Props {
    title: string
    error: AxiosError | null
    conflictStatus: number
}

export const ConflictDialog = ({
    title,
    children,
    error,
    conflictStatus,
}: Props) => {
    const [isEditLectureConflict, setIsEditLectureConflict] = useState(false)

    useEffect(() => {
        // logic status 409
        if (error && error.response.status === conflictStatus) {
            setIsEditLectureConflict(true)
        }
    }, [error])

    return (
        <Dialog
            onClose={() => setIsEditLectureConflict(false)}
            open={isEditLectureConflict}
        >
            <DialogTitle>{title}</DialogTitle>
            <DialogContent>{children}</DialogContent>
            <DialogActions>
                <Button
                    onClick={() => setIsEditLectureConflict(false)}
                    autoFocus
                >
                    Schließen
                </Button>
            </DialogActions>
        </Dialog>
    )
}
