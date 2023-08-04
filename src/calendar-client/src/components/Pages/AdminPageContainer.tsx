import {
    Box,
} from '@mui/material'
import { CalendarList } from '../Settings/Calendar/CalendarList'
import { LectureList } from '../Settings/Lectures/LectureList'


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
