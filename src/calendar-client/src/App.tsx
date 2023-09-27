import { AuthProvider, AuthProviderProps } from 'oidc-react'
import { useEnvironment } from './hooks/useEnvironment'
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider'
import { QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'
import { AdapterMoment } from '@mui/x-date-pickers/AdapterMoment'
import moment from 'moment'
import 'moment/dist/locale/de'

import { queryClient } from './utils/queryClient'
import { RouterComponent } from './components/RouterComponent'
import { ErrorPage } from './components/pages/ErrorPage'
import { ErrorBoundary } from 'react-error-boundary'

function App() {
    moment.locale('de')
    const envConfig = useEnvironment()
    console.log('envConfig', envConfig)
    const oidcConfig: AuthProviderProps = {
        loadUserInfo: true,
        autoSignOut: true,
        autoSignIn: false,
        authority: envConfig.getAuthorityUrl(),
        automaticSilentRenew: true,
        clientId: 'calendar-client',
        scope: '',
        clientSecret: envConfig.OIDC_CLIENT_SECRET,
        redirectUri: envConfig.OIDC_REDIRECT_URL,
        silentRedirectUri: envConfig.OIDC_REDIRECT_URL,
        postLogoutRedirectUri: envConfig.OIDC_REDIRECT_URL,
    }
    return (
        <ErrorBoundary FallbackComponent={ErrorPage}>
            <AuthProvider {...oidcConfig}>
                {/* eslint-disable-next-line @typescript-eslint/no-unsafe-assignment */}
                <QueryClientProvider client={queryClient}>
                    <LocalizationProvider
                        dateAdapter={AdapterMoment}
                        adapterLocale="de"
                    >
                        <RouterComponent />
                    </LocalizationProvider>
                    {envConfig.QUERY_USE_DEVTOOL && <ReactQueryDevtools />}
                </QueryClientProvider>
            </AuthProvider>
        </ErrorBoundary>
    )
}

export default App
