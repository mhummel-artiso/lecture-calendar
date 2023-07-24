import React, { FC, useEffect, useState } from 'react'
import { AuthContextProps, useAuth, User } from 'oidc-react'
import viteLogo from './assets/vite.svg'
import reactLogo from './assets/react.svg'

export const LogedInPage = () => {
    // const [userData, setUserData] = useState<any>()
    const auth: AuthContextProps = useAuth()
    useEffect(() => {
        console.log('auth', auth)
        // const temp=auth.userData?.access_token;
        // auth.userManager.getUser().then(u => {
        //     console.log('u', u);
        // }).catch(e => console.error(e));
    }, [])
    const logout = async (): Promise<void> => {
        console.log('logout')
        await auth
            .signOut()
            .then((e) => console.log(e))
            .catch((e) => console.log('e', e))
    }
    const login = async (): Promise<void> => {
        await auth.signIn().catch((e) => console.log('e', e))
    }
    if (auth.userData) {
        return (
            <>
                <div>
                    <a href="https://vitejs.dev" target="_blank">
                        <img src={viteLogo} className="logo" alt="Vite logo" />
                    </a>
                    <a href="https://react.dev" target="_blank">
                        <img
                            src={reactLogo}
                            className="logo react"
                            alt="React logo"
                        />
                    </a>
                </div>
                <h1>Vite + React</h1>
                <div className="card">
                    <button onClick={logout}>Logout</button>
                    <p>
                        Edit <code>src/App.tsx</code> and save to test HMR
                    </p>
                </div>
                <p className="read-the-docs">
                    Click on the Vite and React logos to learn more
                </p>
            </>
        )
    } else {
        return (
            <div>
                Not Logedin
                <button onClick={login}>Login</button>
            </div>
        )
    }
}
