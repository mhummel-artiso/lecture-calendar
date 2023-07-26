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
import { AxiosResponse } from 'axios'
import { Calendar } from '../models/calendar'
import { axiosInstance } from '../utils/axiosInstance'
import { useQuery } from '@tanstack/react-query'

interface props {
    handleClose: () => void
}

export const DrawerContent = ({ handleClose }: props) => {
    const navigate = useNavigate()

    const fetchCalendar = async (): Promise<Calendar[]> => {
        const response = await axiosInstance.get<Calendar[]>('Calendar')
        return Promise.resolve(response.data)
    }

    const { isLoading, data, isError, error, isFetching } = useQuery({
        queryKey: ['calendars'],
        queryFn: fetchCalendar,
    })

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
                {data?.map((calendar, index) => (
                    <ListItem key={index} disablePadding>
                        <ListItemButton
                            onClick={() =>
                                navigate(`/calendar/${calendar.name}`, {
                                    state: calendar,
                                })
                            }
                        >
                            <ListItemIcon>
                                <CalendarTodayIcon />
                            </ListItemIcon>
                            <ListItemText primary={calendar.name} />
                        </ListItemButton>
                    </ListItem>
                ))}
            </List>
        </Box>
    )
}
