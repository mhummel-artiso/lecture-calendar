import {
    Box,
    Divider,
    ListItem,
    List,
    ListItemButton,
    ListItemIcon,
    ListItemText,
} from '@mui/material'
import React from 'react'
import SettingsIcon from '@mui/icons-material/Settings'
import CalendarTodayIcon from '@mui/icons-material/CalendarToday'
import { useNavigate } from 'react-router-dom'

interface props {
    handleClose: () => void
}

export const DrawerContent = ({ handleClose }: props) => {
    const navigate = useNavigate()
    const [courseList, setCourseList] = React.useState([
        { id: 1, value: 'tin20', label: 'TIN20' },
        { id: 2, value: 'tin21', label: 'TIN21' },
        { id: 3, value: 'tin22', label: 'TIN22' },
    ])

    return (
        <Box role="presentation" onClick={handleClose} sx={{ width: '400px' }}>
            <List>
                <ListItem key="1" disablePadding>
                    <ListItemButton
                        selected
                        onClick={() => navigate('/administration')}
                    >
                        <ListItemIcon>
                            <SettingsIcon />
                        </ListItemIcon>
                        <ListItemText primary={'Übersicht'} />
                    </ListItemButton>
                </ListItem>
            </List>
            <Divider />
            <List>
                {courseList.map((course, index) => (
                    <ListItem key={index} disablePadding>
                        <ListItemButton
                            onClick={() =>
                                navigate(`/calendar/${course.value}`)
                            }
                        >
                            <ListItemIcon>
                                <CalendarTodayIcon />
                            </ListItemIcon>
                            <ListItemText primary={course.label} />
                        </ListItemButton>
                    </ListItem>
                ))}
            </List>
        </Box>
    )
}
