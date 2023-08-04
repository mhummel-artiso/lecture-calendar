export interface DialogComponentProps<T> {
    isDialogOpen: boolean
    handleDialogAbort?: () => void
    handleDialogAdd?: (valueToAdd: T) => void
    handleDialogEdit?: (valueToUpdate: T) => void
    currentValue: T | null
}