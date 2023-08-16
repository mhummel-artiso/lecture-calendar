export interface EnvConfig {
    QUERY_USE_DEVTOOL: boolean
    API_URL: string
    OIDC_AUTO_SIGN_IN: boolean
    OIDC_AUTHORITY: string
    OIDC_CLIENT_SECRET: string
    OIDC_REDIRECT_URL: string
    OIDC_ACCOUNT_URL: string
    BASE_URL: string
}

export const useEnvironment = (): EnvConfig => {
    return getGlobalEnv()
}

export const getGlobalEnv = (): EnvConfig => {
    return {
        API_URL: import.meta.env.VITE_API_URL as string,
        OIDC_AUTO_SIGN_IN: (import.meta.env.VITE_OIDC_AUTO_SIGN_IN ??
            false) as boolean,
        OIDC_AUTHORITY: import.meta.env.VITE_OIDC_AUTHORITY as string,
        OIDC_CLIENT_SECRET: import.meta.env.VITE_OIDC_CLIENT_SECRET as string,
        OIDC_REDIRECT_URL: import.meta.env.VITE_OIDC_REDIRECT_URL as string,
        OIDC_ACCOUNT_URL: import.meta.env.VITE_OIDC_ACCOUNT_URL as string,
        BASE_URL: import.meta.env.BASE_URL,
        QUERY_USE_DEVTOOL: (import.meta.env.VITE_QUERY_USE_DEVTOOL ??
            false) as boolean,
    }
}
