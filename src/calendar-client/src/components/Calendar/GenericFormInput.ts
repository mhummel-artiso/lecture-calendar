export interface GenericFormInput<T> {
    value: T|undefined;
    onChange: (value: T) => void;
    readonlyValue?: string
}