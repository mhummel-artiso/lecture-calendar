import { useAccount } from "../../hooks/useAccount";
import { Avatar, IconButton, Menu, MenuItem, Typography } from "@mui/material";
import React, { FC } from "react";
import MenuIcon from "@mui/icons-material/Menu";
import { useEnvironment } from "../../hooks/useEnvironment";

interface Props {
    onLogoutClick: () => void;
}

export const AccountButton: FC<Props> = ({onLogoutClick}) => {
    const {OIDC_ACCOUNT_URL} = useEnvironment();
    const {userAccount} = useAccount()
    const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);
    const open = Boolean(anchorEl);
    const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
        setAnchorEl(event.currentTarget);
    };

    const handleClose = () => {
        setAnchorEl(null);
    };

    const handelLogoutClick = () => {
        handleClose();
        onLogoutClick()
    }

    const handelMyAccountClick = () => {
        handleClose()
        if(OIDC_ACCOUNT_URL) {
            window.open(`${OIDC_ACCOUNT_URL}/#/personal-info`,'_blank')
        }
    }

    return (<>
            <IconButton
                aria-controls={open ? 'basic-menu' : undefined}
                aria-haspopup="true"
                aria-expanded={open ? 'true' : undefined}
                onClick={handleClick}
            >
                <Avatar alt={userAccount?.name} src={userAccount?.picture??userAccount?.name}/>
            </IconButton>
            <Menu anchorEl={anchorEl}
                  open={open}
                  onClose={handleClose}
                  MenuListProps={{
                      'aria-labelledby': 'basic-button',
                  }}>
                <MenuItem disabled>
                    {userAccount?.name??""}
                </MenuItem>
                <MenuItem onClick={handelMyAccountClick}>Mein Account</MenuItem>
                <MenuItem onClick={handelLogoutClick}>Logout</MenuItem>
            </Menu>
        </>
    )
}