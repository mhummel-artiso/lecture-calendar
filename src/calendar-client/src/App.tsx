import './App.css'
import { AuthProvider } from 'oidc-react'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'

import React from 'react'

function App() {
    const oidcConfig = {
        onSignIn: () => {
            // Redirect?
        },
        authority: 'https://localhost:8080/oauth',
        clientId: 'this-is-a-client-id',
        redirectUri: 'https://my-app.com/',
    }

    const router = createBrowserRouter([
        {
            path: '/',
            element: <div>Hello world!</div>,
        },
        {
            path: '/test',
            element: <div>Test</div>,
        },
        {
            path: '/*',
            element: <div>404</div>,
        },
    ])

    return (
        <AuthProvider {...oidcConfig}>
            <RouterProvider router={router} />
        </AuthProvider>
    )
}

export default App
