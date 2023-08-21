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
import { useAccount } from '../../hooks/useAccount'
import {
    PassedDialogValues,
    AddOrEditEventDialogContent,
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
    isEditConflict: boolean
}

export type TextFieldViewType = 'required' | 'time' | 'optional'
export const EventDialog: FC<EventDialogComponentProps> = ({
    isDialogOpen,
    onDialogClose,
    onDeletedEvent,
    onDialogAdd,
    onDialogEdit,
    currentValue,
    calendarId,
    isEditConflict,
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
            if (onDialogEdit && editSeries) {
                const data: UpdateCalendarEventSeries = {
                    ...base,
                    ...currentValue,
                    endSeries: value.serieEnd,
                    lectureId: value.lectureId,
                }
                onDialogEdit({
                    calendarId: currentValue.calendarId,
                    eventSeries: data,
                    event: undefined,
                })
            } else if (onDialogEdit && !editSeries) {
                const data: UpdateCalendarEvent = {
                    ...base,
                    ...currentValue,
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
        } else if (onDialogAdd) {
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

            {isEditConflict && (
                <EditEventSeriesDialogContent
                    title="Datenkonflikt"
                    onCanceled={handleCancelAskDialog}
                >
                    <Typography>
                        Ihre Änderungen konnten nicht gespeichert werden, da Sie
                        sonst neue Änderungen von einem Kollegen überschreiben
                        würden. Bitte schließen Sie den Dialog, und schauen Sie
                        sich die neuen Änderungen an und probieren Sie es
                        gegebenenfalls erneut.
                    </Typography>
                </EditEventSeriesDialogContent>
            )}

            {!askEditSeries && !askDeleteSeries && !isEditConflict && (
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
                    isConflict={isEditConflict}
                />
            )}
        </Dialog>
    )
}
