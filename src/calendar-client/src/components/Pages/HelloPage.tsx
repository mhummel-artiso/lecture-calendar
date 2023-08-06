import { AvailableCalendarsList } from "../AvailableCalendarsList";
import React from "react";
import { Grid, Typography } from "@mui/material";

export const HelloPage=()=>
{
    return (
        <>
            <Grid container
                  direction="column"
                  justifyContent="center"
                  alignItems="center" 
                  sx={{
                    minHeight: '90vh',
                    display: 'flex',
                  }}>
                <Typography variant="h3">
                    Deine Kurse
                </Typography>
                <AvailableCalendarsList />
            </Grid>
        </>
    )
}