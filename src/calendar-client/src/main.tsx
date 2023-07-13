import React from 'react'
import ReactDOM from 'react-dom/client'
import { AuthProvider } from 'oidc-react';
import App from './App'
import './index.css'

const oidcConfig = {
  onSignIn: () => {
    // Redirect?
  },
  authority: 'https://localhost:/oauth',
  clientId: 'this-is-a-client-id',
  redirectUri: 'https://my-app.com/',
};  

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <AuthProvider {...oidcConfig}>
      <App />
    </AuthProvider>
  </React.StrictMode>,
)
