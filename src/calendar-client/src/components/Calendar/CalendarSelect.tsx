import { useQuery } from "@tanstack/react-query"
import { getCalendars } from "../../services/CalendarService"
import { CircularProgress, MenuItem, TextField } from "@mui/material"
import { FC } from "react"
import { GenericFormInput } from "./GenericFormInput"
import { useAccount } from "../../hooks/useAccount"

export const CalendarSelect: FC<GenericFormInput<string>> = ({value, onChange,readonlyValue}) => {
    const {canEdit} = useAccount();
    const {data, isLoading} = useQuery({
        queryKey: ['calendars'],
        queryFn: getCalendars,
        useErrorBoundary: true
    })

    return !canEdit ? <TextField disabled label="Kurs" value={readonlyValue??"Fehler"}/> : isLoading ? (
        <CircularProgress/>
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
