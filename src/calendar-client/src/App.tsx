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

function App() {
    const [user, setUser] = useState<User|null>(null)

    const oidcConfig: AuthProviderProps = {
        onSignIn: (user) => {
            // Redirect?
            console.log('user', user, window.location);
            setUser(user);
        },
        onSignOut: (props) => {
            console.log('props', props);
        },
        // loadUserInfo: true,
        // authority: 'http://localhost:8080/realms/master',
        // // autoSignIn: true,
        // clientId: 'calendar-client',
        // clientSecret: 'Wo9T9nS0ebJbUpVso6wpOGgVluQaqajA',
        // redirectUri: 'http://localhost:3000',
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
