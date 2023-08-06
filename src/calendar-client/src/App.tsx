import { Routes, Route, Link, BrowserRouter } from 'react-router-dom'

import React from 'react'
import { CalendarPage } from './components/Pages/CalendarPage'
import { AdminPage } from './components/Pages/AdminPageContainer'
import { NotFoundPage } from './components/Pages/NotFoundPage'
import { AuthProvider, AuthProviderProps, User } from 'oidc-react'
import { useEnvironment } from './hooks/useEnvironment'
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider'
import { QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'
import { AdapterMoment } from '@mui/x-date-pickers/AdapterMoment';
import 'moment/locale/de';

import { queryClient } from './utils/queryClient'
import { RouterComponent } from "./components/RouterComponent";

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
        authority: envConfig.VITE_OIDC_AUTHORITY,
        clientId: "calendar-client",
        clientSecret:  envConfig.VITE_OIDC_CLIENT_SECRET,
        redirectUri: envConfig.VITE_OIDC_REDIRECT_URL,
        postLogoutRedirectUri: envConfig.VITE_OIDC_REDIRECT_URL,
    };

    return (
        <AuthProvider {...oidcConfig}>
            {/* eslint-disable-next-line @typescript-eslint/no-unsafe-assignment */}
            <QueryClientProvider client={queryClient}>
                <LocalizationProvider
                    dateAdapter={AdapterMoment}
                    adapterLocale="de"
                >
                    <RouterComponent/>
                </LocalizationProvider>
                {envConfig.QUERY_USE_DEVTOOL && <ReactQueryDevtools/>}
            </QueryClientProvider>
        </AuthProvider>
    )
}

export default App
