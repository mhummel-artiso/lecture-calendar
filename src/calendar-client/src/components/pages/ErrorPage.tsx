import React, { FC } from 'react'
import { Button, Container, Grid } from '@mui/material'
import { FallbackProps } from 'react-error-boundary'
import { queryClient } from '../../utils/queryClient'
import { AxiosError } from 'axios'
import {
    AxiosErrorInformation,
    ErrorInformation,
} from '../ErrorContent/AxiosErrorInformation'

export const ErrorPage: FC<FallbackProps> = ({
    error: err,
    resetErrorBoundary,
}) => {
    return (
        <>
            <Container>
                <Grid
                    container
                    direction="column"
                    spacing={4}
                    justifyContent="center"
                    alignItems="center"
                >
                    {err instanceof AxiosError ? (
                        <AxiosErrorInformation error={err} />
                    ) : err instanceof Error ? (
                        <ErrorInformation error={err} />
                    ) : null}
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
        </>
    )
}
