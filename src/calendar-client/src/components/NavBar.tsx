import {
    AppBar,
    Button,
    Drawer,
    IconButton,
    Toolbar,
    Typography,
} from '@mui/material'
import MenuIcon from '@mui/icons-material/Menu'
import React, { useState } from 'react'
import { DrawerContent } from './DrawerContent'
import { useLocation } from 'react-router'
import { Calendar } from '../models/calendar'

export const NavBar = () => {
    const [drawerActive, setDrawerActive] = useState(false)
    const location = useLocation()
    const state: Calendar | undefined = location.state
        ? (location.state as Calendar)
        : undefined

    const displayText = () => {
        let displayName = 'Kalender'
        // TODO: Check if user is authorized
        if (location.pathname.startsWith('/administration')) {
            displayName = 'Übersicht'
        } else if (location.pathname.startsWith('/calendar/')) {
            displayName = state ? `Kalender: ${state.name}` : 'Kalender'
        }
        return displayName
    }

    const isEditor = true
    return (
        <AppBar position="sticky">
            <Toolbar>
                {isEditor && (
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
                <Button color="inherit">Abmelden</Button>
            </Toolbar>
            {isEditor && (
                <Drawer
                    open={drawerActive}
                    onClose={() => setDrawerActive(false)}
                >
                    <DrawerContent handleClose={() => setDrawerActive(false)} />
                </Drawer>
            )}
        </AppBar>
    )
}
