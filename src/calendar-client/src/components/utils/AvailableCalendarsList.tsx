import {
    Box,
    CircularProgress,
    List,
    ListItem,
    ListItemButton,
    ListItemIcon,
    ListItemText,
    Typography
} from "@mui/material";
import CalendarTodayIcon from "@mui/icons-material/CalendarToday";
import React, { FC, useEffect, useState } from "react";
import { Calendar } from "../../models/calendar";
import { useQuery } from "@tanstack/react-query";
import { useNavigate } from "react-router-dom";
import { getCalendars } from "../../services/CalendarService";

interface Props {
    disablePadding?: boolean
}

export const AvailableCalendarsList: FC<Props> = ({disablePadding}) => {
    const navigate = useNavigate()
    const [calendars, setCalendars] = useState<Calendar[]>([])

    const {isLoading, data, isError, error, isFetching} = useQuery({
        queryKey: ['calendars'],
        queryFn: getCalendars,
        useErrorBoundary: true,
    })
    useEffect(() => {

        setCalendars(data ?? []);
    }, [data])
    return isLoading ? (
        <Box margin={2}>
            <CircularProgress/>
        </Box>
    ) : (
        <List>
            {/*Display text if no calendars available*/}
            {!calendars || data?.length == 0 && (
                <ListItem disablePadding={disablePadding}>
                    <ListItemText primary={"Kein Kalender verfügbar"}/>
                </ListItem>)}
            {/* Display option if more than one calendar is visible */}
            {calendars && calendars.length > 1 && (
                <ListItem disablePadding={disablePadding}>
                    <ListItemButton
                        onClick={() =>
                            navigate(`/calendar`, {
                                state: [...calendars]
                            })
                        }
                    >
                        <ListItemIcon>
                            <CalendarTodayIcon/>
                        </ListItemIcon>
                        <ListItemText primary={"Alle Events anzeigen"}/>
                    </ListItemButton>
                </ListItem>
            )}
            {/* List the available calendars */}
            {calendars.map((calendar, index) => (
                <ListItem key={index} disablePadding={disablePadding}>
                    <ListItemButton
                        onClick={() =>
                            navigate(`/calendar/${calendar.name}`, {
                                state: [calendar],
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