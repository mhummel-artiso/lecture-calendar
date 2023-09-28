import { useAccount } from '../../hooks/useAccount'
import { Avatar, Divider, IconButton, Menu, MenuItem } from '@mui/material'
import React, { FC } from 'react'

interface Props {
    onLogoutClick: () => void
}

export const AccountButton: FC<Props> = ({ onLogoutClick }) => {
    const { userAccount } = useAccount()
    const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null)
    const open = Boolean(anchorEl)
    const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
        setAnchorEl(event.currentTarget)
    }

    const handleClose = () => {
        setAnchorEl(null)
    }

    const handleLogoutClick = () => {
        handleClose()
        onLogoutClick()
    }

    // Handles redirect to Keycloak or Grafana
    const handleExternalLinkClick = (url:string) => {
        handleClose()
            window.open("http://localhost/"+url+"/", '_blank')
    }
    return (
        <>
            <IconButton
                aria-controls={open ? 'basic-menu' : undefined}
                aria-haspopup="true"
                aria-expanded={open ? 'true' : undefined}
                onClick={handleClick}
            >
                <Avatar
                    alt={userAccount?.name}
                    src={userAccount?.picture ?? userAccount?.name}
                />
            </IconButton>
            <Menu
                anchorEl={anchorEl}
                open={open}
                onClose={handleClose}
                MenuListProps={{
                    'aria-labelledby': 'basic-button',
                }}
            >
                <MenuItem disabled>{userAccount?.name ?? ''}</MenuItem>
                <MenuItem onClick={handleLogoutClick}>Logout</MenuItem>
                <Divider/>
                <MenuItem onClick={()=>handleExternalLinkClick("auth")}>Keycloak</MenuItem>
                <MenuItem onClick={()=>handleExternalLinkClick("grafana")}>Grafana</MenuItem>
            </Menu>
        </>
    )
}
