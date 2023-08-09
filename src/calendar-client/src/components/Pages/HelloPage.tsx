import { AvailableCalendarsList } from "../utils/AvailableCalendarsList";
import React from "react";
import { Box, Button, Container, Grid, Typography } from "@mui/material";
import { useAccount } from "../../hooks/useAccount";

export const HelloPage = () => {
    const {isLoggedIn, signIn} = useAccount();
    return isLoggedIn ? (
        <Container>
            <Typography variant="h3">
                Deine Kurse
            </Typography>
            <AvailableCalendarsList/>
        </Container>
    ) : (
        <Container>
            <Box sx={{display: 'flex', flexDirection: 'column', flexGrow: 1, margin:"auto",alignItems:"center",alignContent:"center"}}>
                <Typography variant="h3">
                    Bitte Anmelden
                </Typography>
                <Button variant={"contained"} onClick={signIn}>
                    Anmelden
                </Button>
            </Box>
        </Container>
    )
}