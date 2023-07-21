export interface EnvConfig {
    VITE_API_URL:string;
    VITE_OIDC_AUTHORITY:string;
    VITE_OIDC_CLIENT_SECRET:string;
    BASE_URL:string;
}
export const useEnvironment = () => {
    return {
        VITE_API_URL: import.meta.env.VITE_API_URL as string,
        VITE_OIDC_AUTHORITY: import.meta.env.VITE_OIDC_AUTHORITY as string,
        VITE_OIDC_CLIENT_SECRET: import.meta.env.VITE_OIDC_CLIENT_SECRET as string,
        BASE_URL: import.meta.env.BASE_URL,
    };
}