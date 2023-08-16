import { FC } from 'react'
import { Box } from '@mui/material'
import { NavBar } from './navigation/NavBar'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import { HelloPage } from './pages/HelloPage'
import { CalendarPage } from './Calendar/CalendarPage'
import { AdminPage } from './adminComponents/AdminPageContainer'
import { NotFoundPage } from './pages/NotFoundPage'
import { useAccount } from '../hooks/useAccount'

export const RouterComponent: FC = () => {
    const { canEdit, isLoggedIn } = useAccount()

    return (
        <BrowserRouter>
            <Box
                sx={{
                    display: 'flex',
                    height: '100vh',
                    flexDirection: 'column',
                }}
            >
                <NavBar />
                <Routes>
                    <Route path="/" element={<HelloPage />} />
                    {isLoggedIn && (
                        <>
                            <Route
                                path="/calendar"
                                element={<CalendarPage />}
                            />
                            <Route
                                path="/calendar/:calendarName"
                                element={<CalendarPage />}
                            />
                            {/* Only for administrator.*/}
                            {canEdit && (
                                <Route
                                    path="/administration"
                                    element={<AdminPage />}
                                />
                            )}
                        </>
                    )}
                    <Route path="*" element={<NotFoundPage />} />
                </Routes>
            </Box>
        </BrowserRouter>
    )
}
