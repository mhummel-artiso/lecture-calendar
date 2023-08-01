import {
    Box,
    Fab,
    Grid,
    Typography,
} from '@mui/material'
import React, { useState } from 'react'
import AddIcon from '@mui/icons-material/Add'
import { LectureDialog } from '../components/LectureDialog'
import { CalendarList } from '../components/CalendarList'
import { LectureList } from '../components/LectureList'
import { Calendar } from '../models/calendar'
import { Lecture } from '../models/lecture'


export const AdminPage = () => {
    return (
        <Box
            sx={{ display: 'flex', flexDirection: 'column', flexGrow: 1 }}
            margin={5}
        >
            <CalendarList/>
            <LectureList/>
        </Box>
    )
}
