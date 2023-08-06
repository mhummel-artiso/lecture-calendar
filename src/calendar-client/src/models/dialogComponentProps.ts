export interface DialogComponentProps<T> {
    isDialogOpen: boolean
    onDialogClose: () => void
    onDialogAdd?: (valueToAdd: T) => void
    onDialogEdit?: (valueToUpdate: T) => void
    currentValue: T | null
}