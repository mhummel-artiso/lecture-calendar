import { KeycloakCalendar } from '../models/calendar';
import { Instructor } from '../models/instructor';
import { axiosInstance } from '../utils/axiosInstance'
const keycloakEndPointName = (type: 'instructors'|'calendars') => {
    return `Keycloak/${type}`
};

export const getInstructors= async () => {
    const response = await axiosInstance.get<Instructor[]>(keycloakEndPointName("instructors"))
    return Promise.resolve(response.data)
}
export const getCalendarGroups= async () => {
    const response = await axiosInstance.get<KeycloakCalendar[]>(keycloakEndPointName("calendars"))
    return Promise.resolve(response.data)
}