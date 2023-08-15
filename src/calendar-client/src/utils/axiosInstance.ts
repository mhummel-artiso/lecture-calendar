import axios from 'axios'
import { getGlobalEnv, useEnvironment } from '../hooks/useEnvironment'

const buildAxiosInstance = () => {
    const instance = axios.create()
    instance.defaults.baseURL = getGlobalEnv().API_URL
    instance.defaults.headers.common['Content-Type'] = 'application/json'
    return instance
}

export const axiosInstance = buildAxiosInstance()

// axiosInstance.interceptors.request.use(async (config) => {
//     const account = msalInstance.getAllAccounts()[0];
//     if (account) {
//         try {
//             const tokenResponse = await msalInstance.acquireTokenSilent({
//                 ...loginRequest,
//                 account: account,
//             });
//
//             if (tokenResponse) {
//                 const accessToken = tokenResponse.accessToken;
//
//                 if (config.headers && accessToken) {
//                     config.headers['Authorization'] = 'Bearer ' + accessToken;
//                 }
//             }
//         } catch (error) {
//             // If silent acquisition fails, it could be due to the user changing their password,
//             // their refresh token expiring, or other factors.
//             // In this case, you can call acquireTokenPopup or acquireTokenRedirect to have the user re-authenticate.
//             if (error instanceof InteractionRequiredAuthError) {
//                 try {
//                     const tokenResponse = await msalInstance.acquireTokenPopup(loginRequest);
//
//                     if (tokenResponse) {
//                         const accessToken = tokenResponse.accessToken;
//
//                         if (config.headers && accessToken) {
//                             config.headers['Authorization'] = 'Bearer ' + accessToken;
//                         }
//                     }
//                 } catch (err) {
//                     console.log(err);
//                 }
//             }
//         }
//     }
//     return config;
// });
