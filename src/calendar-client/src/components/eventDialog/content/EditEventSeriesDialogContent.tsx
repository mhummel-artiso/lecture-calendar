import {
    Button,
    DialogActions,
    DialogContent,
    DialogTitle,
} from '@mui/material'
import { FC } from 'react'
import { PassedDialogValues } from './AddOrEditEventDialogContent'

interface Props {
    onCanceled: () => void
    onAccepted: (
        value: PassedDialogValues | undefined,
        editSeries: boolean
    ) => void
    title: string
    children?: React.ReactNode
    value?: PassedDialogValues
}

// Dialog that opens when editing an event thats in a series to check if all series events
// should be updated or only one event
export const EditEventSeriesDialogContent: FC<Props> = ({
    onAccepted,
    onCanceled,
    title,
    children,
    value,
}) => {
    return (
        <>
            <DialogTitle>{title}</DialogTitle>
            <DialogContent>{children}</DialogContent>
            <DialogActions>
                <Button onClick={onCanceled}>Abbrechen</Button>
                <Button
                    variant="contained"
                    onClick={() => {
                        onAccepted(value, true)
                    }}
                >
                    Alle Elemente
                </Button>
                <Button
                    variant="contained"
                    onClick={() => {
                        onAccepted(value, false)
                    }}
                >
                    Nur diese
                </Button>
            </DialogActions>
        </>
    )
}
