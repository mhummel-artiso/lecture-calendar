import { useQuery } from '@tanstack/react-query'
import { getAssignedCalendars } from '../../../services/CalendarService'
import { Autocomplete, CircularProgress, TextField } from '@mui/material'
import { FC, useEffect, useState } from 'react'
import { DialogSelectInterfaces } from '../DialogSelectInterfaces'
import { useAccount } from '../../../hooks/useAccount'
import { Calendar } from '../../../models/calendar'

// Dropdown to select calendar when adding/editing an event
export const CalendarSelect: FC<DialogSelectInterfaces<string>> = ({
    value,
    onChange,
    readonlyValue,
    disabled,
}) => {
    const { canEdit } = useAccount()
    const [selectedValue, setSelectedValue] = useState<Calendar | null>(null)

    const { data, isLoading } = useQuery({
        queryKey: ['calendars'],
        queryFn: getAssignedCalendars,
        useErrorBoundary: true,
        enabled: canEdit,
    })

    useEffect(() => {
        if (data) {
            setSelectedValue(data.find((item) => item.id === value) ?? null)
        }
    }, [data, value])

    return (
        <Autocomplete
            disabled={disabled}
            disablePortal
            value={selectedValue}
            onChange={(_, v) => {
                setSelectedValue(v)
                onChange(v?.id ?? '')
            }}
            options={data ?? []}
            getOptionLabel={(option) => option.name}
            renderInput={(params) => (
                <TextField
                    {...params}
                    label="Kurs"
                    InputProps={{
                        ...params.InputProps,
                        readOnly: !canEdit,
                        endAdornment: (
                            <>
                                {isLoading && canEdit && (
                                    <CircularProgress
                                        color="inherit"
                                        size={20}
                                    />
                                )}
                                {params.InputProps.endAdornment}
                            </>
                        ),
                    }}
                />
            )}
        />
    )
}
