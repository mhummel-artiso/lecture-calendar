import { axiosInstance } from '../utils/axiosInstance'
import { KeycloakCalendar } from '../models/keycloakCalendar'

const path = 'Keycloak'

export const getCalendarsFromKeycloak = async (): Promise<
    KeycloakCalendar[]
> => {
    const response = await axiosInstance.get<KeycloakCalendar[]>(
        path + '/calendars'
    )
    return Promise.resolve(response.data)
}
