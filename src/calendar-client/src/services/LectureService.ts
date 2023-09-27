import { Lecture } from '../models/lecture'
import { axiosInstance } from '../utils/axiosInstance'

const lectureEndPointName = (lectureId: string | null = null) => {
    const path = 'Lecture'
    return lectureId ? path + `/${lectureId}` : path
}
export const addLecture = async (lecture: Lecture): Promise<Lecture> => {
    const response = await axiosInstance.post<Lecture>(
        lectureEndPointName(),
        lecture
    )
    return Promise.resolve(response.data)
}

export const getLecture = async (lectureId: string): Promise<Lecture> => {
    const response = await axiosInstance.get<Lecture>(
        lectureEndPointName(lectureId)
    )
    return Promise.resolve(response.data)
}

export const getLectures = async (): Promise<Lecture[]> => {
    const response = await axiosInstance.get<Lecture[]>(lectureEndPointName())
    return Promise.resolve(response.data)
}

export const editLecture = async (
    lectureId: string,
    lecture: Lecture
): Promise<Lecture> => {
    const response = await axiosInstance.put<Lecture>(
        lectureEndPointName(lectureId),
        lecture
    )
    return Promise.resolve(response.data)
}

export const deleteLecture = async (lectureId: string): Promise<boolean> => {
    const response = await axiosInstance.delete<boolean>(
        lectureEndPointName(lectureId)
    )
    return Promise.resolve(response.data)
}
