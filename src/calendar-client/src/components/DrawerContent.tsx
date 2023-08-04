import {
    Box,
    Divider,
    ListItem,
    List,
    ListItemButton,
    ListItemIcon,
    ListItemText,
} from '@mui/material'
import React, { useEffect, useState } from 'react'
import SettingsIcon from '@mui/icons-material/Settings'
import CalendarTodayIcon from '@mui/icons-material/CalendarToday'
import { useNavigate } from 'react-router-dom'
import { AxiosResponse } from 'axios'
import { Calendar, CombinedCalendar } from '../models/calendar'
import { axiosInstance } from '../utils/axiosInstance'
import { useQuery } from '@tanstack/react-query'
import { useAccount } from "../hooks/useAccount";
import { AvailableCalendarsList } from "./AvailableCalendarsList";

interface props {
    handleClose: () => void
}

export const DrawerContent = ({handleClose}: props) => {
    const navigate = useNavigate();
    const [calendars, setCalendars] = useState<(Calendar | CombinedCalendar)[]>([]);
    const {canEdit} = useAccount();

    return (
        <Box role="presentation" onClick={handleClose} sx={{width: '400px'}}>
            <List>
                {canEdit() && <>
                    <ListItem key="1" disablePadding>
                        <ListItemButton
                            selected
                            onClick={() => navigate('/administration')}
                        >
                            <ListItemIcon>
                                <SettingsIcon/>
                            </ListItemIcon>
                            <ListItemText primary={'Übersicht'}/>
                        </ListItemButton>
                    </ListItem>
                    <Divider sx={{margin: 1}}/>
                </>}
            </List>
            <AvailableCalendarsList />
        </Box>
    )
}
