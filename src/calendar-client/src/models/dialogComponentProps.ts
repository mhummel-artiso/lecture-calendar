export interface DialogComponentProps<T, TAdd, TEdit> {
    isDialogOpen: boolean
    onDialogClose: () => void
    onDialogAdd?: (valueToAdd: TAdd) => void
    onDialogEdit?: (valueToUpdate: TEdit) => void
    currentValue: T | null
}
