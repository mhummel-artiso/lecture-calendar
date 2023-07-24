import { Routes, Route, Link, BrowserRouter } from 'react-router-dom'

import React from 'react'
import { CalendarPage } from './pages/CalendarPage'
import { AdminPage } from './pages/AdminPage'
import { NotFoundPage } from './pages/NotFoundPage'
import { Grid } from '@mui/material'
import { NavBar } from './components/NavBar'
import { AuthProvider, AuthProviderProps, User } from 'oidc-react'
import { useEnvironment } from './hooks/useEnvironment.tsx'
function App() {
    const envConfig = useEnvironment()
    const oidcConfig: AuthProviderProps = {
        onSignIn: (user) => {
            // Redirect?
            console.log('user', user, window.location)
        },
        onSignOut: (props) => {
            console.log('props', props)
            window.location.href = envConfig.VITE_OIDC_REDIRECT_URL
        },
        loadUserInfo: true,
        autoSignIn: false,
        authority: envConfig.VITE_OIDC_AUTHORITY,
        clientId: 'calendar-client',
        clientSecret: envConfig.VITE_OIDC_CLIENT_SECRET,
        redirectUri: envConfig.VITE_OIDC_REDIRECT_URL,
        postLogoutRedirectUri: 'http://localhost:3000/logedout',
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
