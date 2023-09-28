import {
    Button,
    CircularProgress,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    MenuItem,
    Stack,
    TextField,
} from '@mui/material'
import { FC, useEffect, useState } from 'react'
import { Calendar } from '../../../models/calendar'
import { DatePicker } from '@mui/x-date-pickers/DatePicker'
import { Moment } from 'moment/moment'
import moment from 'moment'
import { DialogComponentProps } from '../../../models/dialogComponentProps'
import { useQuery } from '@tanstack/react-query'
import { getAssignedCalendars } from '../../../services/CalendarService'
import { getCalendarsFromKeycloak } from '../../../services/KeyCloakService'

// Dialog to add / edit calendars
export const CalendarDialog: FC<
    DialogComponentProps<Calendar, Calendar, Calendar>
> = ({
    isDialogOpen,
    onDialogClose,
    onDialogAdd,
    onDialogEdit,
    currentValue: currentCalendar,
}) => {
    const [name, setName] = useState<string>('')
    const [startDate, setStartDate] = useState<Moment | null>(moment())

    // Initialise the form fields with current calendar data if available 
    useEffect(() => {
        setName(currentCalendar?.name ?? '')
        setStartDate(
            currentCalendar ? moment(currentCalendar.startDate) : moment()
        )
    }, [currentCalendar, isDialogOpen])

    const handleSubmitClick = () => {
        if (!startDate) {
            return
        }
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

    // Query available calendars from Keycloak
    const {
        data: keycloakCalendarsData,
        isLoading: isKeycloakCalendarsLoading,
    } = useQuery({
        queryKey: ['availableCalendars'],
        queryFn: getCalendarsFromKeycloak,
        useErrorBoundary: true,
    })

    const { data: calendarsData, isLoading: isCalendarLoading } = useQuery({
        queryKey: ['calendars'],
        queryFn: getAssignedCalendars,
        useErrorBoundary: true,
    })

    // Generate a list of calendars from Keycloak to add to application
    const getPendingCalendars = () => {
        if (keycloakCalendarsData && calendarsData) {
            const calendars = keycloakCalendarsData.filter(
                (x) =>
                    !calendarsData.some(
                        (y) => y.name.toLowerCase() === x.name.toLowerCase()
                    )
            )
            if (calendars.length === 0) {
                return (
                    <>
                        <MenuItem disabled={true} value={undefined}>
                            Keine weiteren Kalender zum Hinzufügen
                        </MenuItem>
                    </>
                )
            }
            return calendars.map((value, index) => (
                <MenuItem key={index} value={value.name}>
                    {value.name}
                </MenuItem>
            ))
        } else {
            return (
                <MenuItem disabled={true} value={undefined}>
                    Keine Kalender verfügbar
                </MenuItem>
            )
        }
    }

    const selectLoadingSpinner = () => {
        if (isKeycloakCalendarsLoading && isCalendarLoading) {
            return <CircularProgress />
        } else {
            return <></>
        }
    }

    return (
        <Dialog open={isDialogOpen} onClose={onDialogClose}>
            <DialogTitle>
                Kalender {currentCalendar == null ? 'hinzufügen' : 'Info'}
            </DialogTitle>
            <DialogContent sx={{ width: '500px' }}>
                <Stack>
                    {currentCalendar ? (
                        <TextField
                            id="outlined-read-only-input"
                            label="Kalendername"
                            defaultValue={currentCalendar.name}
                            InputProps={{
                                readOnly: true,
                            }}
                            sx={{ marginTop: 1 }}
                        ></TextField>
                    ) : (
                        <>
                            <TextField
                                fullWidth
                                value={name}
                                onChange={(e) => setName(e.target.value)}
                                select
                                InputProps={{
                                    startAdornment: selectLoadingSpinner(),
                                }}
                                label="Name"
                            >
                                {getPendingCalendars()}
                            </TextField>
                        </>
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
