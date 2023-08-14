import { useQuery } from "@tanstack/react-query"
import { getLectures } from "../../services/LectureService"
import { CircularProgress, MenuItem, TextField } from "@mui/material"
import { FC } from "react"
import { GenericFormInput } from "./GenericFormInput"
import { useAccount } from "../../hooks/useAccount"

export const LectureSelect: FC<GenericFormInput<string>> = ({value, onChange,readonlyValue}) => {
    const {canEdit} = useAccount();
    const {data, isLoading} = useQuery({
        queryKey: ['lectures'],
        queryFn: getLectures,
        useErrorBoundary: true
    })
    return !canEdit ? <TextField disabled label="Vorlesung" value={readonlyValue??"Fehler"}/> :
        isLoading ? (
            <CircularProgress/>
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