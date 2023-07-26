import { Routes, Route, Link, BrowserRouter } from 'react-router-dom'

import React from 'react'
import { CalendarPage } from './pages/CalendarPage'
import { AdminPage } from './pages/AdminPage'
import { NotFoundPage } from './pages/NotFoundPage'
import { AuthProvider, AuthProviderProps, User } from 'oidc-react'
import { useEnvironment } from './hooks/useEnvironment.tsx'
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs'
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider'
import { QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'

import 'dayjs/locale/de'
import { queryClient } from './utils/queryClient'

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
        postLogoutRedirectUri: 'http://localhost:3000',
    }

    return (
        <AuthProvider {...oidcConfig}>
            {/* eslint-disable-next-line @typescript-eslint/no-unsafe-assignment */}
            <QueryClientProvider client={queryClient}>
                <LocalizationProvider
                    dateAdapter={AdapterDayjs}
                    adapterLocale="de"
                >
                    <BrowserRouter>
                        <Routes>
                            <Route path="/" element={<CalendarPage />} />
                            {/* This page is only for administrator to see specific calendars.*/}
                            <Route
                                path="/calendar/:calendarName"
                                element={<CalendarPage />}
                            />
                            {/* Only for administrator.*/}
                            <Route
                                path="/administration"
                                element={<AdminPage />}
                            />
                            <Route path="*" element={<NotFoundPage />} />
                        </Routes>
                    </BrowserRouter>
                </LocalizationProvider>
                <ReactQueryDevtools />
            </QueryClientProvider>
        </AuthProvider>
    )
}

export default App
