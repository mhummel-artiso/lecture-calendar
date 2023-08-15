import {
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    FormControl,
    InputLabel,
    MenuItem,
    Select,
    SelectChangeEvent,
    Stack,
    TextField,
} from '@mui/material'
import React, { FC, useEffect, useState } from 'react'
import { Calendar } from '../../../models/calendar'
import { DatePicker } from '@mui/x-date-pickers/DatePicker'
import { Moment } from 'moment/moment'
import moment from 'moment'
import { DialogComponentProps } from '../../../models/dialogComponentProps'
import { useQuery } from '@tanstack/react-query'
import { getCalendars } from '../../../services/CalendarService'
import { getCalendarsFromKeycloak } from '../../../services/KeycloakDataService'
import { KeycloakCalendar } from '../../../models/keycloakCalendar'

export const CalendarDialog: FC<DialogComponentProps<Calendar>> = ({
    isDialogOpen,
    onDialogClose,
    onDialogAdd,
    onDialogEdit,
    currentValue: currentCalendar,
}) => {
    const [name, setName] = useState('')
    const [startDate, setStartDate] = useState<Moment>(moment())

    useEffect(() => {
        setName(currentCalendar?.name ?? '')
        setStartDate(
            currentCalendar ? moment(currentCalendar.startDate) : moment()
        )
    }, [currentCalendar, isDialogOpen])

    const handleSubmitClick = () => {
        const c: Calendar = {
            id: currentCalendar?.id,
            name,
            startDate: startDate.clone(),
        }
        if (onDialogAdd && currentCalendar == null) {
            onDialogAdd(c)
        } else if (onDialogEdit) {
            onDialogEdit(c)
        }
        onDialogClose()
    }

    const {
        data: keycloakCalendarsData,
        isLoading: isKeycloakCalendarsLoading,
    } = useQuery({
        queryKey: ['keycloakcalendars'],
        queryFn: getCalendarsFromKeycloak,
        useErrorBoundary: true,
    })

    const { data: calendarsData, isLoading: isCalendarLoading } = useQuery({
        queryKey: ['calendars'],
        queryFn: getCalendars,
        useErrorBoundary: true,
    })

    const getPendingCalendars = (
        allCalendars: KeycloakCalendar[] | undefined,
        createdCalendars: Calendar[] | undefined
    ): KeycloakCalendar[] => {
        if (allCalendars && createdCalendars) {
            const pending = allCalendars.filter(
                (x) =>
                    !createdCalendars.some(
                        (y) => y.name.toLowerCase() === x.name.toLowerCase()
                    )
            )
            return pending
        } else {
            return []
        }
    }

    useEffect(() => {
        console.log('name', name)
    }, [name])

    return (
        <Dialog open={isDialogOpen} onClose={onDialogClose}>
            <DialogTitle>
                Kalender {currentCalendar == null ? 'hinzufügen' : 'bearbeiten'}
            </DialogTitle>
            <DialogContent sx={{ width: '500px' }}>
                <Stack>
                    <FormControl fullWidth sx={{ marginTop: 1 }}>
                        <InputLabel id="demo-simple-select-label">
                            Name
                        </InputLabel>
                        <Select
                            labelId="demo-simple-select-label"
                            id="demo-simple-select"
                            value={name}
                            label="Name"
                            onChange={(e: SelectChangeEvent) =>
                                setName(e.target.value)
                            }
                        >
                            {getPendingCalendars(
                                keycloakCalendarsData,
                                calendarsData
                            ).map((value, index) => {
                                return (
                                    <MenuItem key={index} value={value.name}>
                                        {value.name}
                                    </MenuItem>
                                )
                            })}
                            {getPendingCalendars(
                                keycloakCalendarsData,
                                calendarsData
                            ).length === 0 && (
                                <MenuItem disabled={true} value={'noCalendars'}>
                                    Keine Kalender zum Hinzufügen
                                </MenuItem>
                            )}
                        </Select>
                    </FormControl>
                    <DatePicker
                        sx={{ mt: 2 }}
                        label="Startdatum"
                        value={startDate}
                        onChange={(e) => setStartDate(e)}
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={onDialogClose}>Abbrechen</Button>
                <Button
                    disabled={!name && !!startDate}
                    onClick={handleSubmitClick}
                >
                    {currentCalendar == null ? 'Hinzufügen' : 'Bearbeiten'}
                </Button>
            </DialogActions>
        </Dialog>
    )
}
