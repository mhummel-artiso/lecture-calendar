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

export const CalendarDialog: FC<DialogComponentProps<Calendar, Calendar, Calendar>> = ({
                                                                                           isDialogOpen,
                                                                                           onDialogClose,
                                                                                           onDialogAdd,
                                                                                           onDialogEdit,
                                                                                           currentValue: currentCalendar
                                                                                       }) => {
    const [name, setName] = useState<string>("");
    const [startDate, setStartDate] = useState<Moment | null>(moment());

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
            return allCalendars.filter(
                (x) =>
                    !createdCalendars.some(
                        (y) => y.name.toLowerCase() === x.name.toLowerCase()
                    )
            )
        } else {
            return []
        }
    }

    return (
        <Dialog open={isDialogOpen} onClose={onDialogClose}>
            <DialogTitle>
                Kalender {currentCalendar == null ? 'hinzufügen' : 'Info'}
            </DialogTitle>
            <DialogContent sx={{ width: '500px' }}>
                <Stack>
                    {currentCalendar !== null && (
                        <TextField
                            id="outlined-read-only-input"
                            label="Name"
                            defaultValue={currentCalendar.name}
                            InputProps={{
                                readOnly: true,
                            }}
                            sx={{ marginTop: 1 }}
                        />
                    )}

                    {currentCalendar === null && (
                        <FormControl sx={{ marginTop: 1 }}>
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
                                        <MenuItem
                                            key={index}
                                            value={value.name}
                                        >
                                            {value.name}
                                        </MenuItem>
                                    )
                                })}
                                {getPendingCalendars(
                                    keycloakCalendarsData,
                                    calendarsData
                                ).length === 0 && (
                                    <MenuItem
                                        disabled={true}
                                        value={'noCalendars'}
                                    >
                                        Keine weiteren Kalender zum Hinzufügen
                                    </MenuItem>
                                )}
                            </Select>
                        </FormControl>
                    )}
                    <DatePicker
                        sx={{ mt: 2 }}
                        label="Startdatum"
                        value={startDate}
                        onChange={(e) => setStartDate(e)}
                        readOnly={currentCalendar !== null}
                    />
                </Stack>
            </DialogContent>
            <DialogActions>
                <Button onClick={onDialogClose}>
                    {currentCalendar === null ? 'Abbrechen' : 'Schließen'}
                </Button>

                {currentCalendar == null && (
                    <Button
                        disabled={!name && !!startDate}
                        onClick={handleSubmitClick}
                    >
                        Hinzufügen
                    </Button>
                )}
            </DialogActions>
        </Dialog>
    )
}
