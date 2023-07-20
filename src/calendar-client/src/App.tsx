import React, { useState } from 'react'
import './App.css'
import { AuthProvider, AuthProviderProps, User } from 'oidc-react';
import {
    Routes,
    Route,
    // Link,
    // useNavigate,
    // useLocation,
    // Navigate,
    // Outlet,
} from "react-router-dom";
import { LogedInPage } from "./LogedInPage.tsx";
import { useEnvironment } from './hooks/useEnvironment.tsx';

function App() {
    const [user, setUser] = useState<User|null>(null)
    const envConfig=useEnvironment();
    const oidcConfig: AuthProviderProps = {
        onSignIn: (user) => {
            // Redirect?
            console.log('user', user, window.location);
            setUser(user);
        },
        onSignOut: (props) => {
            console.log('props', props);
        },
        loadUserInfo: true,
        autoSignIn: true,
        authority: envConfig.VITE_OIDC_AUTHORITY,
        clientId: "calendar-client",
        clientSecret:  envConfig.VITE_OIDC_CLIENT_SECRET,
        redirectUri: envConfig.BASE_URL,
    };

    return (
        <AuthProvider {...oidcConfig}>
            <Routes>
                <Route caseSensitive={true} path="/" element={<LogedInPage />}>
                </Route>

            </Routes>
        </ AuthProvider>
    )
}

export default App
