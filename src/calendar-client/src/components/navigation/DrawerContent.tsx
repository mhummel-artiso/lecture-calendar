import {
    Box,
    Divider,
    List,
    ListItem,
    ListItemButton,
    ListItemIcon,
    ListItemText,
} from '@mui/material'
import React from 'react'
import SettingsIcon from '@mui/icons-material/Settings'
import { useNavigate } from 'react-router-dom'
import { useAccount } from '../../hooks/useAccount'
import { AvailableCalendarsList } from '../utils/AvailableCalendarsList'

interface props {
    handleClose: () => void
}

// Dropdown of calendars that shows in menu
export const DrawerContent = ({ handleClose }: props) => {
    const navigate = useNavigate()
    const { canEdit } = useAccount()

    return (
        <Box role="presentation" onClick={handleClose} sx={{ width: '400px' }}>
            <List>
                {/* Show administration page if user can edit data  */}
                {canEdit && (
                    <>
                        <ListItem key="1" disablePadding>
                            <ListItemButton
                                selected
                                onClick={() => navigate('/administration')}
                            >
                                <ListItemIcon>
                                    <SettingsIcon />
                                </ListItemIcon>
                                <ListItemText primary={'Übersicht'} />
                            </ListItemButton>
                        </ListItem>
                        <Divider sx={{ margin: 1 }} />
                    </>
                )}
            </List>
            <AvailableCalendarsList disablePadding />
        </Box>
    )
}
