import React from "react";

export interface DialogSelectInterfaces<T> {
    value: T | undefined | null;
    onChange: (value: T | null) => void;
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