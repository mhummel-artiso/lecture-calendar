import React, { FC, useEffect, useState } from 'react'
import { Button, Container, Grid, Typography } from '@mui/material'
import {
    ErrorBoundaryProps,
    FallbackProps,
    withErrorBoundary,
} from 'react-error-boundary'
import App from '../../App'
import { Image } from '@mui/icons-material'
import { AxiosError } from 'axios'
import { queryClient } from '../../utils/queryClient'

export const ErrorPage: FC<FallbackProps> = ({
    error: err,
    resetErrorBoundary,
}) => {
    const getError = () => {
        if(err instanceof AxiosError) {
            return (<>
                <Typography sx={{maxWidth: "80%"}}>
                    {err.message} {err?.statusText}
                </Typography>
                {err?.response?.data?.split('\n').map(l => (
                    <Typography sx={{maxWidth: "80%"}}>
                        {l}
                    </Typography>))}
            </>)
        }
        if (err instanceof Error) {
            return err?.stack
                ?.split('\n')
                .map((l) => (
                    <Typography sx={{ maxWidth: '80%' }}>{l}</Typography>
                ))
        }
    }
    return (
        <Container>
            <Grid
                container
                direction="column"
                spacing={4}
                justifyContent="center"
                alignItems="center"
                sx={{ minHeight: '50%' }}
            >
                <img src="https://cdn.dribbble.com/users/285475/screenshots/2083086/media/bbcfd1a1fecd97c1835792283a601f10.gif" />
                <Typography variant="h2">
                    Ein Fehler ist aufgetreten:
                </Typography>
                {getError()}
                <Button
                    variant={'outlined'}
                    onClick={() => {
                        queryClient.clear()
                        resetErrorBoundary()
                    }}
                >
                    Ok
                </Button>
            </Grid>
        </Container>
    )
}
