import { useQuery } from "@tanstack/react-query"
import { getLectures } from "../../../services/LectureService"
import { CircularProgress, Grid, MenuItem, TextField } from "@mui/material"
import { FC } from "react"
import { DialogInterfaces } from "../../Calendar/DialogInterfaces"
import { useAccount } from "../../../hooks/useAccount"

export const LectureSelect: FC<DialogInterfaces<string>> = ({value, onChange,readonlyValue,disabled}) => {
    const {data, isLoading} = useQuery({
        queryKey: ['lectures'],
        queryFn: getLectures,
        useErrorBoundary: true
    })
    return disabled ? <TextField disabled label="Vorlesung" value={readonlyValue??"Fehler"}/> :
        isLoading ? (
            <Grid container>
                <Grid item xs={5}/>
                <Grid item xs={2}><CircularProgress/></Grid>
                <Grid item xs={5}/>
            </Grid>
        ) : (
            <TextField
                fullWidth
                value={value}
                onChange={(e) => onChange(e.target.value)}
                select
                id={"vorlesung"}
                label="Vorlesung"
            >
                {(data ?? []).map((item) => (
                    <MenuItem key={item.id} value={item.id}>
                        {item.title}
                    </MenuItem>
                ))}
            </TextField>
        )
}