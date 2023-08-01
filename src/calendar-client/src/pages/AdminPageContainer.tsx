import {
    Box,
} from '@mui/material'
import { CalendarList } from '../components/CalendarList'
import { LectureList } from '../components/LectureList'


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
