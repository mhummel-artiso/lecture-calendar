import { AvailableCalendarsList } from "../utils/AvailableCalendarsList";
import React from "react";
import { Box, Container, Grid, Typography } from "@mui/material";

export const HelloPage = () => {
    return (
        <Container>
            <Typography variant="h3">
                Deine Kurse
            </Typography>
            <AvailableCalendarsList/>
        </Container>
    )
}