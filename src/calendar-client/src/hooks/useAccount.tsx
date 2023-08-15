import { useEffect, useState } from 'react'
import { useAuth } from 'oidc-react'
import { axiosInstance } from '../utils/axiosInstance'
import { UserProfile } from 'oidc-client-ts'
import { queryClient } from '../utils/queryClient'

export const useAccount = () => {
    const { userData, signOut, signIn } = useAuth()
    const [isLoggedIn, setIsLoggedIn] = useState<boolean>(false)
    const [userAccount, setUserAccount] = useState<UserProfile | null>(null)
    const [canEdit, setCanEdit] = useState<boolean>(false)
    useEffect(() => {
        const loggedIn = !!userData
        setIsLoggedIn(loggedIn)
        axiosInstance.defaults.headers['Authorization'] = userData
            ? 'Bearer ' + userData.access_token
            : ''
        setUserAccount(userData?.profile ?? null)
        setCanEdit(_canEdit())
        if (!loggedIn) {
            queryClient.clear()
        }
    }, [userData])
    const _canEdit: boolean = () => {
        if (userData?.profile?.realm_access) {
            const roles =
                (userData?.profile?.realm_access[0]['roles'] as string[]) ?? []
            const index = roles.findIndex((x) => x === 'calendar-editor')
            return index !== -1
        }
        return false
    }

    return {
        userAccount,
        signIn,
        signOut,
        isLoggedIn,
        canEdit,
    }
}
