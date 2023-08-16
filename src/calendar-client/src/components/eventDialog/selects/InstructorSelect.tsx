import { FC } from "react";
import { useQuery } from "@tanstack/react-query"
import { DialogSelectInterfaces } from "../DialogSelectInterfaces";
import { CircularProgress, Autocomplete, TextField } from "@mui/material"
import { Instructor } from "../../../models/instructor";
import { getInstructors } from "../../../services/KeyCloakService";
import { useAccount } from "../../../hooks/useAccount";

export const InstructorSelect: FC<DialogSelectInterfaces<Instructor[]>> = ({value, onChange}) => {
    const {canEdit} = useAccount();

    const {data, isLoading} = useQuery({
        queryKey: ['instructors'],
        queryFn: getInstructors,
        useErrorBoundary: true,
        enabled: canEdit,
    })

    return (
        <Autocomplete
            disabled={!canEdit}
            disablePortal
            options={data ?? []}
            multiple
            aria-required
            onChange={(e, newValue) => onChange(newValue)}
            value={value}
            getOptionLabel={(option) => option.name}
            renderInput={
                (params) => <TextField
                    {...params}
                    label="Dozenten"
                    InputProps={{
                        ...params.InputProps,
                        readOnly: !canEdit,
                        endAdornment: (<>
                            {isLoading && canEdit && <CircularProgress color="inherit" size={20}/>}
                            {params.InputProps.endAdornment}
                        </>)
                    }}
                />}
        />
    );
}