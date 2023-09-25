import { useAccount } from '../../hooks/useAccount'
import { Avatar, Divider, IconButton, Menu, MenuItem } from '@mui/material'
import React, { FC } from 'react'
import { useEnvironment } from '../../hooks/useEnvironment'

interface Props {
    onLogoutClick: () => void
}

export const AccountButton: FC<Props> = ({ onLogoutClick }) => {
    const { getAuthorityUrl } = useEnvironment()
    const { userAccount } = useAccount()
    const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null)
    const open = Boolean(anchorEl)
    const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
        setAnchorEl(event.currentTarget)
    }

    const handleClose = () => {
        setAnchorEl(null)
    }

    const handelLogoutClick = () => {
        handleClose()
        onLogoutClick()
    }
    const handelExternalLinkClick = (url:string) => {
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
                <MenuItem onClick={handelLogoutClick}>Logout</MenuItem>
                <Divider/>
                <MenuItem onClick={()=>handelExternalLinkClick("auth")}>Keycloak</MenuItem>
                <MenuItem onClick={()=>handelExternalLinkClick("grafana")}>Grafana</MenuItem>
            </Menu>
        </>
    )
}
