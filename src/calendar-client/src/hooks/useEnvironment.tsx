export interface EnvConfig {
    VITE_API_URL:string;
    VITE_OIDC_AUTHORITY:string;
    VITE_OIDC_CLIENT_SECRET:string;
    BASE_URL:string;
}
export const useEnvironment = () => {
    if(!import.meta.env.VITE_API_URL) throw new Error('VITE_API_URL not set')
    if(!import.meta.env.VITE_OIDC_AUTHORITY) throw new Error('VITE_OIDC_AUTHORITY not set')
    if(!import.meta.env.VITE_OIDC_CLIENT_SECRET) throw new Error('VITE_OIDC_CLIENT_SECRET not set')
    return {
        VITE_API_URL: import.meta.env.VITE_API_URL as string,
        VITE_OIDC_AUTHORITY: import.meta.env.VITE_OIDC_AUTHORITY as string,
        VITE_OIDC_CLIENT_SECRET: import.meta.env.VITE_OIDC_CLIENT_SECRET as string,
        BASE_URL: import.meta.env.BASE_URL,
    };
}