import { useEffect, useState } from 'react'
import { useAuth, User } from 'oidc-react'
import { axiosInstance } from '../utils/axiosInstance'
import { UserProfile } from 'oidc-client-ts'
import { queryClient } from '../utils/queryClient'

const _canEdit = (user: User | null | undefined): boolean => {
    if (user?.profile?.realm_access) {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
        const realm_access = user.profile.realm_access as [claim: string]
        const roles = (realm_access[0]['roles'] as string[]) ?? []
        const index = roles.findIndex((x) => x === 'calendar-editor')
        return index !== -1
    }
    return false
}

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
        setCanEdit(_canEdit(userData))
        if (!loggedIn) {
            queryClient.clear()
        }
    }, [userData])

    return {
        userAccount,
        signIn,
        signOut,
        isLoggedIn,
        canEdit,
    }
}
