import { Button, DialogActions, DialogContent, DialogTitle, Typography } from "@mui/material";
import { FC } from "react";

interface Props {
    onCanceled: () => void;
    onAccepted: (edidSeries: boolean) => void;
    title: string;
    children?: React.ReactNode;
}

export const EditEventSeriesDialogContent: FC<Props> = ({onAccepted, onCanceled, title, children}) => {
    return (<>
        <DialogTitle>
            {title}
        </DialogTitle>
        <DialogContent>
            {children}
        </DialogContent>
        <DialogActions>
            <Button onClick={onCanceled}>Abbrechen</Button>
            <Button variant="contained" onClick={() => {onAccepted(true)}}>Alle Elemente</Button>
            <Button variant="contained" onClick={() => {onAccepted(false)}}>Nur diese</Button>
        </DialogActions>
    </>)
}