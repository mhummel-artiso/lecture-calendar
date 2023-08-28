import {
    Fab,
    Grid,
    ToggleButton,
    ToggleButtonGroup,
    Typography,
} from '@mui/material'
import React, { FC } from "react";
import { CalendarViewType } from "./CalendarPage";

interface Props {
    value: CalendarViewType
    onChange: (value: CalendarViewType) => void
}

export const CalendarViewSwitch: React.FC<Props> = ({value, onChange,}) => {
    const handleViewChange = (
        event: React.MouseEvent<HTMLElement>,
        newAlignment: CalendarViewType | null
    ) => {
        if(newAlignment) {
            onChange(newAlignment)
        }
    }
    return (<Grid item xl={2} md={3} xs={12} container
                  justifyContent="flex-end"
                  alignItems="center">
        <ToggleButtonGroup
            color="primary"
            value={value}
            exclusive
            onChange={handleViewChange}
            aria-label="Platform"
        >
            <ToggleButton value="month">Monat</ToggleButton>
            <ToggleButton value="week">Woche</ToggleButton>
            <ToggleButton value="day">Tag</ToggleButton>
        </ToggleButtonGroup>
    </Grid>)
}