import { Routes, Route, Link, BrowserRouter } from 'react-router-dom'

import React from 'react'
import { CalendarPage } from './components/Pages/CalendarPage'
import { AdminPage } from './components/Pages/AdminPageContainer'
import { NotFoundPage } from './components/Pages/NotFoundPage'
import { AuthProvider, AuthProviderProps, User } from 'oidc-react'
import { useEnvironment } from './hooks/useEnvironment'
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs'
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider'
import { QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'

import 'dayjs/locale/de'
import { queryClient } from './utils/queryClient'
import { NavBar } from './components/NavBar'
import { Box } from '@mui/material'
import { useAccount } from "./hooks/useAccount";
import { HelloPage } from "./components/Pages/HelloPage";
import { ErrorBoundary } from "react-error-boundary";
import { ErrorPage } from "./components/Pages/ErrorPage";

function App() {
    const envConfig = useEnvironment()
    const oidcConfig: AuthProviderProps = {
        onSignIn: (user) => {
            // Redirect?
            console.log('user', user, window.location)
        },
        onSignOut: (props) => {
            console.log('props', props)
            window.location.href = envConfig.OIDC_REDIRECT_URL
        },
        loadUserInfo: true,
        autoSignIn: false,
        authority: envConfig.OIDC_AUTHORITY,
        clientId: 'calendar-client',
        clientSecret: envConfig.OIDC_CLIENT_SECRET,
        redirectUri: envConfig.OIDC_REDIRECT_URL,
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
                            <Box
                                sx={{
                                    display: 'flex',
                                    height: '100%',
                                    flexDirection: 'column',
                                }}
                            >
                                <NavBar/>
                                <ErrorBoundary FallbackComponent={ErrorPage} >
                                <Routes>
                                    <Route path="/" element={<HelloPage/>}/>
                                    <Route path="/calendar" element={<HelloPage/>}/>
                                    {/* This page is only for administrator to see specific calendars.*/}
                                    <Route
                                        path="/calendar/:calendarName"
                                        element={<CalendarPage/>}
                                    />
                                    {/* Only for administrator.*/}
                                    <Route
                                        path="/administration"
                                        element={<AdminPage/>}
                                    />
                                    <Route path="*" element={<NotFoundPage/>}/>
                                </Routes>
                                </ErrorBoundary>
                            </Box>
                        </BrowserRouter>
                    </LocalizationProvider>
                    {envConfig.QUERY_USE_DEVTOOL && <ReactQueryDevtools/>}
                </QueryClientProvider>
            </AuthProvider>
    )
}

export default App
