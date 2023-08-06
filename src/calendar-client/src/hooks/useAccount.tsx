import { useEffect, useState } from "react";
import { useAuth } from "oidc-react";
import { axiosInstance } from "../utils/axiosInstance";
import { UserProfile } from "oidc-client-ts";
import { useQueryClient } from "@tanstack/react-query";

export const useAccount = () => {
    const {userData, signOut, signIn} = useAuth();
    const [isLoggedIn, setIsLoggedIn] = useState<boolean>(false);
    const [userAccount, setUserAccount] = useState<UserProfile | null>(null);
    const [canEdit, setCanEdit] = useState<boolean>(false);
    useEffect(() => {
        setIsLoggedIn(!!userData)
        axiosInstance.defaults.headers['Authorization'] = userData ? "Bearer " + userData.access_token : "";
        setUserAccount(userData?.profile ?? null)
        setCanEdit(_canEdit())
    }, [userData])
    const _canEdit: boolean = () => {
        if(userData?.profile?.realm_access) {
            const t = userData?.profile?.realm_access[0]['roles'] as string[] ?? [];
            const r = t.findIndex(x => x === 'calendar-editor');
            return r !== -1;
        }
        return false;
    }

    return {
        userAccount,
        signIn,
        signOut,
        isLoggedIn,
        canEdit
    }
}