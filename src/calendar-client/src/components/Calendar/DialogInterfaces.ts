import React from "react";

export interface DialogInterfaces<T> {
    value: T|undefined;
    onChange: (value: T) => void;
    readonlyValue?: string
    disabled?: boolean
}

export interface LayoutDisplayItem {
    lable: string,
    key: string
    required: boolean,
    renderComponent: React.ReactNode,
    errorFn?: () => boolean,
    errorMassage?: string
}