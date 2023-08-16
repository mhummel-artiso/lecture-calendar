import { useQuery } from '@tanstack/react-query'
import { getLectures } from '../../../services/LectureService'
import {
    Autocomplete,
    CircularProgress,
    Grid,
    MenuItem,
    TextField,
} from '@mui/material'
import React, { FC, useEffect, useState } from 'react'
import { DialogSelectInterfaces } from '../DialogSelectInterfaces'
import { useAccount } from '../../../hooks/useAccount'
import { Calendar } from '../../../models/calendar'
import { Lecture } from '../../../models/lecture'

export const LectureSelect: FC<DialogSelectInterfaces<string>> = ({
    value,
    onChange,
    readonlyValue,
    disabled,
}) => {
    const { canEdit } = useAccount()
    const [selectedValue, setSelectedValue] = useState<Lecture | null>(null)
    const { data, isLoading } = useQuery({
        queryKey: ['lectures'],
        queryFn: getLectures,
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
                // setSelectedValue(v)
                onChange(v?.id ?? '')
            }}
            options={data ?? []}
            getOptionLabel={(option) => {
                let title = option.title
                if (option.shortKey) {
                    title = `${title} (${option.shortKey})`
                }
                return title
            }}
            renderInput={(params) => (
                <TextField
                    {...params}
                    label="Vorlesung"
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
