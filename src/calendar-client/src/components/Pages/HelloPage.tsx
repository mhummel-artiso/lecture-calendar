import { AvailableCalendarsList } from '../utils/AvailableCalendarsList'
import React from 'react'
import { Box, Button, Container, Grid, Typography } from '@mui/material'
import { useAccount } from '../../hooks/useAccount'

export const HelloPage = () => {
    const { isLoggedIn, signIn } = useAccount()
    return isLoggedIn ? (
        <Grid container alignItems="center" justifyContent="center" style={{ height: '100vh' }}>
            <Grid item>
                <Typography variant="h3">
                    Deine Kurse
                </Typography>
                <AvailableCalendarsList/>
            </Grid>
        </Grid>
    ) : (
        <Grid container alignItems="center" justifyContent="center" style={{ height: '100vh' }}>
            <Grid item alignContent="center" textAlign="center">
                <Typography variant="h3">
                    Bitte Anmelden
                </Typography>
                <Button variant={"contained"} onClick={signIn}>
                    Anmelden
                </Button>
            </Grid>
        </Grid>
    )
}
