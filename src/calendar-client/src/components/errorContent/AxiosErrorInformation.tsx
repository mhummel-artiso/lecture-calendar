import { Typography } from '@mui/material'
import React, { FC } from 'react'
import { AxiosError } from 'axios'

interface Props {
    error: AxiosError
}

export const AxiosErrorInformation: FC<Props> = ({ error }) => {
    // Determine the dialog title based on the error
    const getDialogTitle = () => {
        let text = ''
        if (error === null) {
            text = 'Kein Fehler :)'
        } else if (error.response?.status == 409) {
            text = 'Konflikt beim Übernehmen von Daten'
        } else {
            text = error?.response?.statusText ?? 'Unbekannter Fehler'
        }
        return <Typography variant="h2">{text}</Typography>
    }

    // Determine the dialog content based on the error
    const getDialogContent = () => {
        if (error === null) {
            return <Typography>Keine Fehler :)</Typography>
        }
        // Conflict error when editing event
        if (error.response?.status == 409) {
            return (
                <Typography>
                    Ihre Änderungen konnten nicht gespeichert werden. Bitte
                    schließen Sie den Dialog, um die neueste Version bearbeiten
                    zu können.
                </Typography>
            )
        }
        return <Typography>{error?.message}</Typography>
    }
    return (
        <>
            {getDialogTitle()}
            {getDialogContent()}
        </>
    )
}

export const ErrorInformation = ({ error }: { error: Error }) => {
    const getError = () => {
        return error?.stack
            ?.split('\n')
            .map((l) => <Typography sx={{ maxWidth: '80%' }}>{l}</Typography>)
    }
    return (
        <>
            <img src="https://cdn.dribbble.com/users/285475/screenshots/2083086/media/bbcfd1a1fecd97c1835792283a601f10.gif" />
            <Typography variant="h2">Ein Fehler ist aufgetreten:</Typography>
            {getError()}
        </>
    )
}
