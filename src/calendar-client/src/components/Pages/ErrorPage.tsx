import { FC, useEffect, useState } from "react";
import { Button, Grid, Typography } from "@mui/material";
import { ErrorBoundaryProps, FallbackProps, withErrorBoundary } from 'react-error-boundary'
import App from "../../App";

export const ErrorPage: FC<FallbackProps> = ({error: err, resetErrorBoundary}) => {
    const [error, setError] = useState<Error | undefined>(undefined);
    useEffect(() => {
            console.log('err', err);
            if(err instanceof Error) {
                setError(err);
            }
        },
        [err]
    )

    return (
        <Grid container
              direction="column"
              spacing={4}
              justifyContent="center"
              alignItems="center" sx={{minHeight: "50%"}}>
            <Typography variant="h2">
                Ein Fehler ist aufgetreten:
            </Typography>

            <Typography variant={"h6"}>
                Fehler:
            </Typography>
            {error?.stack?.split('\n').map(l=>(<Typography sx={{maxWidth:"80%"}}>
                {l}
            </Typography>))}
            <Button variant={"outlined"} onClick={resetErrorBoundary}>Ok</Button>
        </Grid>
    )
}
