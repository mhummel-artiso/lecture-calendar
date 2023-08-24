import { AvailableCalendarsList } from '../utils/AvailableCalendarsList'
import React from 'react'
import { Button, Grid, Typography } from '@mui/material'
import { useAccount } from '../../hooks/useAccount'

export const HelloPage = () => {
    const {isLoggedIn, signIn} = useAccount()
    const handelSignIn = ()=> {
        signIn().then()
    }
    return isLoggedIn ? (
        <Grid
            container
            alignItems="center"
            justifyContent="center"
            style={{height: '100vh'}}
        >
            <Grid item>
                <Typography variant="h3">Deine Kurse</Typography>
                <AvailableCalendarsList/>
            </Grid>
        </Grid>
    ) : (
        <Grid
            container
            alignItems="center"
            justifyContent="center"
            style={{height: '100vh'}}
        >
            <Grid item alignContent="center" textAlign="center">
                <Typography variant="h3">Bitte Anmelden</Typography>
                <Button variant={'contained'} onClick={handelSignIn}>
                    Anmelden
                </Button>
            </Grid>
        </Grid>
    )
}
