import { FC } from 'react'
import { Box } from '@mui/material'
import { NavBar } from './navigation/NavBar'
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'
import { HelloPage } from './pages/HelloPage'
import { CalendarPage } from './calendar/CalendarPage'
import { AdminPage } from './adminComponents/AdminPageContainer'
import { NotFoundPage } from './pages/NotFoundPage'
import { useAccount } from '../hooks/useAccount'

export const RouterComponent: FC = () => {
    const { canEdit, isLoggedIn, isLoading } = useAccount()

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

                            {/* Only for administrator*/}
                            {canEdit && (
                                <Route
                                    path="/administration"
                                    element={<AdminPage />}
                                />
                            )}
                        </>
                    )}
                    {!isLoading && (
                        <Route
                            path="*"
                            element={
                                isLoggedIn ? (
                                    <NotFoundPage />
                                ) : (
                                    <Navigate to="/" replace />
                                )
                            }
                        />
                    )}
                </Routes>
            </Box>
        </BrowserRouter>
    )
}
