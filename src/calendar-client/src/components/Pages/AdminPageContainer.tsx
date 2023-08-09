import {
    Box, Container, Stack,
} from '@mui/material'
import { CalendarList } from '../Settings/Calendar/CalendarList'
import { LectureList } from '../Settings/Lectures/LectureList'
import React from "react";


export const AdminPage = () => {
    return (
        <Container>
            <Box sx={{display: 'flex', flexDirection: 'column', flexGrow: 1}}
                 margin={5}>
                <CalendarList/>
                <LectureList/>
            </Box>
        </Container>
    )
}
