import axios from 'axios'
import { getGlobalEnv } from '../hooks/useEnvironment'

const buildAxiosInstance = () => {
    const instance = axios.create()
    const { API_URL, API_HOST } = getGlobalEnv()
    instance.defaults.baseURL = `${API_HOST}${API_URL}`
    instance.defaults.headers.common['Content-Type'] = 'application/json'
    return instance
}

export const axiosInstance = buildAxiosInstance()
