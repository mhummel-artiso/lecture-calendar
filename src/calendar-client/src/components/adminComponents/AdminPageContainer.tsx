import { Box, Container } from '@mui/material'
import { CalendarList } from './calendar/CalendarList'
import { LectureList } from './lectures/LectureList'

// Component to manage calendars and lectures, admin only
export const AdminPage = () => {
    return (
        <Container>
            <Box
                sx={{ display: 'flex', flexDirection: 'column', flexGrow: 1 }}
                margin={5}
            >
                <CalendarList />
                <LectureList />
            </Box>
        </Container>
    )
}
