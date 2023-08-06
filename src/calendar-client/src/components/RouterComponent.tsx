import React, { FC } from "react";
import { Box } from "@mui/material";
import { NavBar } from "./NavBar";
import { ErrorBoundary } from "react-error-boundary";
import { ErrorPage } from "./Pages/ErrorPage";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { HelloPage } from "./Pages/HelloPage";
import { CalendarPage } from "./Pages/CalendarPage";
import { AdminPage } from "./Pages/AdminPageContainer";
import { NotFoundPage } from "./Pages/NotFoundPage";
import { useAccount } from "../hooks/useAccount";

export const RouterComponent: FC = () => {
    const {canEdit} = useAccount();
    return (<BrowserRouter>
        <Box
            sx={{
                display: 'flex',
                height: '100vh',
                flexDirection: 'column',
            }}
        >
            <NavBar/>
            <ErrorBoundary FallbackComponent={ErrorPage}>
                <Routes>
                    <Route path="/" element={<HelloPage/>}/>
                    <Route path="/calendar" element={<CalendarPage/>}/>
                    {/* This page is only for administrator to see specific calendars.*/}
                    <Route
                        path="/calendar/:calendarName"
                        element={<CalendarPage/>}
                    />
                    {/* Only for administrator.*/}
                    {canEdit() && <Route
                        path="/administration"
                        element={<AdminPage/>}
                    />}
                    <Route path="*" element={<NotFoundPage/>}/>
                </Routes>
            </ErrorBoundary>
        </Box>
    </BrowserRouter>)
}