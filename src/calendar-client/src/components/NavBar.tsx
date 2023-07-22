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

export const NavBar = () => {
    const [drawerActive, setDrawerActive] = useState(false)
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
                    Kalender
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
