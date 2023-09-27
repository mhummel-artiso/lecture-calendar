import { Fab, Grid, Typography } from '@mui/material'
import KeyboardArrowLeftIcon from '@mui/icons-material/KeyboardArrowLeft'
import KeyboardArrowRightIcon from '@mui/icons-material/KeyboardArrowRight'
import React from 'react'
import moment, { Moment } from 'moment/moment'
import {
    CalendarViewType,
    formatCurrentDateView,
} from '../../services/DateService'

interface Props {
    currentDate: Moment
    calendarView: CalendarViewType
    onCurrentDateChanged: (date: Moment) => void
}

export const CalendarDateNavigation: React.FC<Props> = ({
    calendarView,
    currentDate,
    onCurrentDateChanged,
}) => {
    const handleDataNavigation = (isForward: boolean) => {
        // Adds or removes 1 day or week or month from currentDate, depending on calendarView
        currentDate.add(isForward ? 1 : -1, calendarView)
        onCurrentDateChanged(moment(currentDate))
    }
    return (
        <Grid
            item
            xl={10}
            md={9}
            xs={12}
            container
            justifyContent="space-between"
            alignItems="center"
        >
            <Fab color="primary" onClick={() => handleDataNavigation(false)}>
                <KeyboardArrowLeftIcon />
            </Fab>
            <Typography variant="subtitle1">
                {formatCurrentDateView(currentDate, calendarView)}
            </Typography>
            <Fab color="primary" onClick={() => handleDataNavigation(true)}>
                <KeyboardArrowRightIcon />
            </Fab>
        </Grid>
    )
}
