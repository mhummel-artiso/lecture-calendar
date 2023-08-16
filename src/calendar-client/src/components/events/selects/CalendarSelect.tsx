import { useQuery } from "@tanstack/react-query"
import { getCalendars } from "../../../services/CalendarService"
import { CircularProgress, Grid, InputProps, MenuItem, TextField } from "@mui/material"
import { FC } from "react"
import { DialogInterfaces } from "../../Calendar/DialogInterfaces"
import { useAccount } from "../../../hooks/useAccount"

export const CalendarSelect: FC<DialogInterfaces<string>> = ({value, onChange, readonlyValue, disabled}) => {
    const {data, isLoading} = useQuery({
        queryKey: ['calendars'],
        queryFn: getCalendars,
        useErrorBoundary: true
    })

    return disabled ? <TextField disabled label="Kurs" value={readonlyValue ?? "null"}/>
        : isLoading ? (
            <Grid container>
                <Grid item xs={5}/>
                <Grid item xs={2}><CircularProgress/></Grid>
                <Grid item xs={5}/>
            </Grid>
        ) : (<TextField
            fullWidth
            value={value}
            onChange={(e) => onChange(e.target.value)}
            select
            label="Kurs"
            id={"kurs"}>
            {(data ?? []).map((item) => (
                <MenuItem key={item.id} value={item.id}>
                    {item.name}
                </MenuItem>
            ))}
        </TextField>)
}
