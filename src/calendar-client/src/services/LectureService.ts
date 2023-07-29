import { Lecture } from '../models/lecture'
import { axiosInstance } from '../utils/axiosInstance'

export const fetchLectures = async (): Promise<Lecture[]> => {
    const response = await axiosInstance.get<Lecture[]>('Lecture')
    return Promise.resolve(response.data)
}
