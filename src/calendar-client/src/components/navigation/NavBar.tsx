import {
    AppBar,
    Avatar,
    Button,
    Drawer,
    IconButton,
    Toolbar,
    Typography,
} from '@mui/material'
import MenuIcon from '@mui/icons-material/Menu'
import React, { useState } from 'react'
import { DrawerContent } from './DrawerContent'
import { useLocation, useNavigate } from 'react-router'
import { Calendar } from '../../models/calendar'
import { useAccount } from '../../hooks/useAccount'
import { AccountButton } from '../utils/AccountButton'

export const NavBar = () => {
    const [drawerActive, setDrawerActive] = useState(false)
    const { signOut, isLoggedIn, signIn, isLoading } = useAccount()
    const location = useLocation()
    const state: Calendar[] | undefined = location.state
        ? (location.state as Calendar[])
        : undefined
    const navigate = useNavigate()

    const displayText = () => {
        let displayName = 'Kalender'
        // TODO: Check if user is authorized
        if (location.pathname.startsWith('/administration')) {
            displayName = 'Übersicht'
        } else if (location.pathname.startsWith('/calendar/')) {
            displayName =
                state?.length == 1 ? `Kalender: ${state[0].name}` : 'Kalender'
        }
        return displayName
    }

    const handleSignOutClick = () => {
        signOut().then(() => navigate('/'))
    }

    // const isEditor = true
    return (
        <AppBar position="sticky">
            <Toolbar>
                {isLoggedIn && (
                    <IconButton
                        size="large"
                        edge="start"
                        color="inherit"
                        aria-label="menu"
                        sx={{ mr: 2 }}
                        onClick={() => setDrawerActive(true)}
                    >
                        <MenuIcon />
                    </IconButton>
                )}
                <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                    {displayText()}
                </Typography>

                {isLoggedIn && (
                    <AccountButton
                        onLogoutClick={handleSignOutClick}
                    ></AccountButton>
                )}

                {!isLoading && !isLoggedIn && (
                    <Button onClick={signIn} color="inherit">
                        Anmelden
                    </Button>
                )}
            </Toolbar>
            <Drawer open={drawerActive} onClose={() => setDrawerActive(false)}>
                <DrawerContent handleClose={() => setDrawerActive(false)} />
            </Drawer>
        </AppBar>
    )
}
