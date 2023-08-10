// export interface DialogComponentProps<T> {
//     isDialogOpen: boolean
//     onDialogClose: () => void
//     onDialogAdd?: (valueToAdd: T) => void
//     onDialogEdit?: (valueToUpdate: T) => void
//     currentValue: T | null
// }

export interface DialogComponentProps<T, TAdd, TEdit> {
    isDialogOpen: boolean
    onDialogClose: () => void
    onDialogAdd?: (valueToAdd: TAdd) => void
    onDialogEdit?: (valueToUpdate: TEdit) => void
    currentValue: T | null
}