import { AuthProvider } from 'oidc-react'
import { Routes, Route, Link, BrowserRouter } from 'react-router-dom'

import React from 'react'
import { CalendarPage } from './pages/CalendarPage'
import { AdminPage } from './pages/AdminPage'
import { NotFoundPage } from './pages/NotFoundPage'
import { Grid } from '@mui/material'
import { NavBar } from './components/NavBar'

function App() {
    const oidcConfig = {
        onSignIn: () => {
            // Redirect?
        },
        authority: 'https://localhost:8080/oauth',
        clientId: 'this-is-a-client-id',
        redirectUri: 'https://my-app.com/',
    }

    return (
        <AuthProvider {...oidcConfig}>
            <BrowserRouter>
                <Routes>
                    <Route path="/" element={<CalendarPage />} />
                    {/* This page is only for administrator to see specific calendars.*/}
                    <Route
                        path="/calendar/:calendarName"
                        element={<CalendarPage />}
                    />
                    {/* Only for administrator.*/}
                    <Route path="/administration" element={<AdminPage />} />
                    <Route path="*" element={<NotFoundPage />} />
                </Routes>
            </BrowserRouter>
        </AuthProvider>
    )
}

export default App
