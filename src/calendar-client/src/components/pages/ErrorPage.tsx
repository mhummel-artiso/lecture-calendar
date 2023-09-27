import React, { FC } from 'react'
import { Button, Container, Grid, Stack } from '@mui/material'
import { FallbackProps } from 'react-error-boundary'
import { queryClient } from '../../utils/queryClient'
import { AxiosError } from 'axios'
import {
    AxiosErrorInformation,
    ErrorInformation,
} from '../errorContent/AxiosErrorInformation'

export const ErrorPage: FC<FallbackProps> = ({
    error: err,
    resetErrorBoundary,
}) => {
    return (
        <Stack
            justifyContent="center"
            alignItems="center"
            style={{ height: '100vh' }}
        >
            {err instanceof AxiosError ? (
                <AxiosErrorInformation error={err} />
            ) : err instanceof Error ? (
                <ErrorInformation error={err} />
            ) : null}
            <Button
                sx={{ marginTop: 2 }}
                variant={'outlined'}
                onClick={() => {
                    queryClient.clear()
                    resetErrorBoundary()
                }}
            >
                Ok
            </Button>
        </Stack>
    )
}
