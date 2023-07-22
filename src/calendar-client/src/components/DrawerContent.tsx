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
                {['TINF2021', 'TINF2022', 'TINF2023'].map((text, index) => (
                    <ListItem key={index} disablePadding>
                        <ListItemButton
                            onClick={() => navigate(`/calendar/${text}`)}
                        >
                            <ListItemIcon>
                                <CalendarTodayIcon />
                            </ListItemIcon>
                            <ListItemText primary={text} />
                        </ListItemButton>
                    </ListItem>
                ))}
            </List>
        </Box>
    )
}
