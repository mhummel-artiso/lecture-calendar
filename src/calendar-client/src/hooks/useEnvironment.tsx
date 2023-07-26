export interface EnvConfig {
    QUERY_USE_DEVTOOL: boolean
    API_URL: string
    OIDC_AUTHORITY: string
    OIDC_CLIENT_SECRET: string
    OIDC_REDIRECT_URL: string
    BASE_URL: string
}
export const useEnvironment = (): EnvConfig => {
    return {
        API_URL: import.meta.env.VITE_API_URL as string,
        OIDC_AUTHORITY: import.meta.env.VITE_OIDC_AUTHORITY as string,
        OIDC_CLIENT_SECRET: import.meta.env.VITE_OIDC_CLIENT_SECRET as string,
        OIDC_REDIRECT_URL: import.meta.env.VITE_OIDC_REDIRECT_URL as string,
        BASE_URL: import.meta.env.BASE_URL,
        QUERY_USE_DEVTOOL: import.meta.env.VITE_QUERY_USE_DEVTOOL as boolean,
    }
}

export const getGlobalEnv = () => {
    console.log('path', import.meta.env)
    return { VITE_API_URL: import.meta.env.VITE_API_URL as string }
}
