export interface EnvConfig {
    QUERY_USE_DEVTOOL: boolean
    API_HOST: string
    API_URL: string
    OIDC_URL: string
    OIDC_AUTO_SIGN_IN: boolean
    OIDC_AUTHORITY: string
    OIDC_CLIENT_SECRET: string
    OIDC_REDIRECT_URL: string
    OIDC_ACCOUNT_URL: string
    BASE_URL: string
}

export const useEnvironment = () => {
    const env = getGlobalEnv()
    return {
        ...env,
        getAuthorityUrl: (): string => `${env.OIDC_URL}${env.OIDC_AUTHORITY}`,
        getAccountUrl: (): string => `${env.OIDC_URL}${env.OIDC_ACCOUNT_URL}`,
    }
}

export const getGlobalEnv = (): EnvConfig => {
    if (!import.meta.env.VITE_API_HOST)
        console.error('VITE_API_HOST is not set')

    if (!import.meta.env.VITE_OIDC_URL)
        console.error('VITE_OIDC_URL is not set')
    if (!import.meta.env.VITE_OIDC_AUTHORITY)
        console.error('VITE_OIDC_AUTHORITY is not set')
    if (!import.meta.env.VITE_OIDC_CLIENT_SECRET)
        console.error('VITE_OIDC_CLIENT_SECRET is not set')
    if (!import.meta.env.VITE_OIDC_REDIRECT_URL)
        console.error('VITE_OIDC_REDIRECT_URL is not set')
    if (!import.meta.env.VITE_OIDC_ACCOUNT_URL)
        console.error('VITE_OIDC_ACCOUNT_URL is not set')
    return {
        API_HOST:
            (import.meta.env.VITE_API_HOST as string) ??
            import.meta.env.BASE_URL,
        API_URL: (import.meta.env.VITE_API_URL as string) ?? '/v1/api',
        OIDC_AUTO_SIGN_IN: (import.meta.env.VITE_OIDC_AUTO_SIGN_IN ??
            false) as boolean,
        OIDC_URL: import.meta.env.VITE_OIDC_URL as string,
        OIDC_AUTHORITY: import.meta.env.VITE_OIDC_AUTHORITY as string,
        OIDC_CLIENT_SECRET: import.meta.env.VITE_OIDC_CLIENT_SECRET as string,
        OIDC_REDIRECT_URL: import.meta.env.VITE_OIDC_REDIRECT_URL as string,
        OIDC_ACCOUNT_URL: import.meta.env.VITE_OIDC_ACCOUNT_URL as string,
        BASE_URL: import.meta.env.BASE_URL,
        QUERY_USE_DEVTOOL: (import.meta.env.VITE_QUERY_USE_DEVTOOL ??
            false) as boolean,
    }
}
