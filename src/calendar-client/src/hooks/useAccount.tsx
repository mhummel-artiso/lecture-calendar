import { useEffect, useState } from "react";
import { useAuth, User } from "oidc-react";
import { axiosInstance } from "../utils/axiosInstance";

export const useAccount = (accountChanged: ((user: User | null | undefined) => void) | undefined = undefined) => {
    const {userData, signOut} = useAuth();

    useEffect(() => {
        axiosInstance.defaults.headers['authorization'] = userData ? "Barer " + userData.access_token : "";
        if(accountChanged) {
            accountChanged(userData);
        }
    }, [userData])

    const isLoggedIn = () => userData != null

    const canEdit = () => true;

    return {
        account: userData,
        signOut,
        isLoggedIn,
        canEdit
    }
}