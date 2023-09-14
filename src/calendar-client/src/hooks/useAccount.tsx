import { useEffect } from 'react'
import { useAuth, User } from 'oidc-react'
import { axiosInstance } from '../utils/axiosInstance'
import { queryClient } from '../utils/queryClient'
import { useErrorBoundary } from 'react-error-boundary'

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
    const { showBoundary } = useErrorBoundary()
    const {
        userData,
        signOut,
        signIn,
        signOutRedirect,
        userManager,
        isLoading,
    } = useAuth()

    useEffect(() => {
        axiosInstance.defaults.headers['Authorization'] = userData
            ? 'Bearer ' + userData.access_token
            : ''
        console.log(
            'axiosInstance.defaults.headers[Authorization]',
            axiosInstance.defaults.headers['Authorization']
        )
        if (userData) {
            queryClient.clear()
        }
    }, [userData])

    const _signOut = async () => {
        const idToken = userData?.id_token
        if (idToken) {
            await signOutRedirect({
                id_token_hint: idToken,
            }).catch(showBoundary)
        }
        await userManager.removeUser()
        await signOut()
    }
    return {
        userAccount: userData?.profile ?? null,
        signIn,
        signOut: _signOut,
        isLoggedIn: !!userData,
        canEdit: _canEdit(userData),
        isLoading,
    }
}
