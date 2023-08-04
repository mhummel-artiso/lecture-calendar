import { List, ListItem, ListItemButton, ListItemIcon, ListItemText, Typography } from "@mui/material";
import CalendarTodayIcon from "@mui/icons-material/CalendarToday";
import React from "react";
import { Calendar } from "../models/calendar";
import { axiosInstance } from "../utils/axiosInstance";
import { useQuery } from "@tanstack/react-query";
import { useNavigate } from "react-router-dom";

export const AvailableCalendarsList=()=>{
    const navigate = useNavigate()
    const fetchCalendar = async (): Promise<Calendar[]> => {
        const response = await axiosInstance.get<Calendar[]>('Calendar')
        return Promise.resolve(response.data)
    }

    const {isLoading, data, isError, error, isFetching} = useQuery({
        queryKey: ['calendars'],
        queryFn: fetchCalendar,
    })
    return (
        <List>
            {data?.length==0 && <ListItem>
                <ListItemText primary={"Kein Kalender verfügbar"}></ListItemText>

            </ListItem>}
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
                            <CalendarTodayIcon/>
                        </ListItemIcon>
                        <ListItemText primary={calendar.name}/>
                    </ListItemButton>
                </ListItem>
            ))}
        </List>
    )
}