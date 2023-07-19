import './App.css'
import { AuthProvider } from 'oidc-react'
import { Button } from '@material-ui/core'

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
            <Button variant="contained">Hello World</Button>
            <h1>Calendar Client</h1>
        </AuthProvider>
    )
}

export default App
