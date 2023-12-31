import { Dialog, Typography } from '@mui/material'
import { FC, useState } from 'react'
import { useMutation } from '@tanstack/react-query'
import {
    CalendarEvent,
    CalendarEventBase,
    CreateCalendarEvent,
    UpdateCalendarEvent,
    UpdateCalendarEventSeries,
} from '../../models/calendarEvent'
import { deleteEvent, deleteEventSeries } from '../../services/CalendarService'
import { DialogComponentProps } from '../../models/dialogComponentProps'
import { EditEventSeriesDialogContent } from './content/EditEventSeriesDialogContent'
import {
    AddOrEditEventDialogContent,
    PassedDialogValues,
} from './content/AddOrEditEventDialogContent'

export interface EditEventCallback {
    calendarId: string
    event?: UpdateCalendarEvent
    eventSeries?: UpdateCalendarEventSeries
}

interface EventDialogComponentProps
    extends DialogComponentProps<
        CalendarEvent,
        CreateCalendarEvent,
        EditEventCallback
    > {
    calendarId: string
    onDeletedEvent: (event: CalendarEvent) => void
}

export type TextFieldViewType = 'required' | 'time' | 'optional'

// Event Dialog, opens when adding/editing an event
export const EventDialog: FC<EventDialogComponentProps> = ({
    isDialogOpen,
    onDialogClose,
    onDeletedEvent,
    onDialogAdd,
    onDialogEdit,
    currentValue,
    calendarId,
}: EventDialogComponentProps) => {
    const [askEditSeries, setAskEditSeries] = useState<
        PassedDialogValues | undefined
    >()
    const [askDeleteSeries, setAskDeleteSeries] = useState<boolean>(false)
    const isEdit = !!currentValue
    const isSeries = currentValue?.repeat !== 0

    const handleClose = () => {
        onDialogClose()
    }

    const handleAddOrEditEvent = (
        value: PassedDialogValues | undefined,
        editSeries: boolean | undefined = undefined
    ) => {
        if (!value) return
        const base: CalendarEventBase = {
            ...value,
        }
        if (currentValue) {
            // Event is a event series
            if (onDialogEdit && editSeries) {
                const data: UpdateCalendarEventSeries = {
                    ...currentValue,
                    ...base,
                    endSeries: value.serieEnd,
                    startSeries: value.serieStart,
                    lectureId: value.lectureId,
                }
                onDialogEdit({
                    calendarId: currentValue.calendarId,
                    eventSeries: data,
                    event: undefined,
                })
            } // Event is not a series
            else if (onDialogEdit && !editSeries) {
                const data: UpdateCalendarEvent = {
                    ...currentValue,
                    ...base,
                    calendarId: currentValue.calendarId,
                    endSeries: value.serieEnd,
                    lectureId: value.lectureId,
                }
                onDialogEdit({
                    calendarId: currentValue.calendarId,
                    event: data,
                    eventSeries: undefined,
                })
            }
        } // Event has to be added as new event
        else if (onDialogAdd) {
            const data: CreateCalendarEvent = {
                ...base,
                lectureId: value.lectureId,
                description: value.description ?? undefined,
                endSeries: value.serieEnd ?? undefined,
            }
            onDialogAdd(data)
        }
        handleClose()
    }

    const deleteEventMutation = useMutation({
        mutationFn: async ({
            calendarId,
            event,
        }: {
            calendarId: string
            event: CalendarEvent
        }) => {
            const result = await deleteEvent(calendarId, event)
            onDeletedEvent(event)
            return result
        },
        onSuccess: (_) => {
            handleClose()
        },
    })
    const deleteEventSeriesMutation = useMutation({
        mutationFn: async ({
            calendarId,
            event,
        }: {
            calendarId: string
            event: CalendarEvent
        }) => {
            const result = await deleteEventSeries(calendarId, event.seriesId)
            onDeletedEvent(event)
            return result
        },
        onSuccess: (_) => {
            handleClose()
        },
    })

    const handleDeleteClick = (deleteSeries = false) => {
        if (!currentValue) {
            return
        }
        if (deleteSeries) {
            deleteEventSeriesMutation.mutate({
                calendarId: currentValue.calendarId,
                event: currentValue,
            })
        } else {
            deleteEventMutation.mutate({
                calendarId: currentValue.calendarId,
                event: currentValue,
            })
        }
    }

    const handleCancelAskDialog = () => {
        setAskDeleteSeries(false)
    }

    return (
        <Dialog open={isDialogOpen} onClose={handleClose}>
            {askEditSeries && (
                <EditEventSeriesDialogContent
                    title="Serie bearbeiten?"
                    value={askEditSeries}
                    onCanceled={handleCancelAskDialog}
                    onAccepted={handleAddOrEditEvent}
                >
                    <Typography>
                        Wollen Sie nur das aktuelle Ereignis oder die gesamte
                        Serie bearbeiten?
                    </Typography>
                </EditEventSeriesDialogContent>
            )}
            {askDeleteSeries && (
                <EditEventSeriesDialogContent
                    title="Serie löschen?"
                    onCanceled={handleCancelAskDialog}
                    onAccepted={(_, deleteSeries) =>
                        handleDeleteClick(deleteSeries)
                    }
                >
                    <Typography>
                        Wollen Sie nur das aktuelle Ereignis oder die gesamte
                        Serie löschen?
                    </Typography>
                </EditEventSeriesDialogContent>
            )}

            {!askEditSeries && !askDeleteSeries && (
                <AddOrEditEventDialogContent
                    isSeries={isSeries}
                    calendarId={calendarId}
                    isEdit={isEdit}
                    currentValue={currentValue}
                    onDelete={() => {
                        if (isSeries) {
                            setAskDeleteSeries(true)
                        } else {
                            handleDeleteClick(false)
                        }
                    }}
                    onAccept={(value) =>
                        isEdit && isSeries
                            ? setAskEditSeries(value)
                            : handleAddOrEditEvent(value)
                    }
                    onCancel={handleClose}
                />
            )}
        </Dialog>
    )
}
