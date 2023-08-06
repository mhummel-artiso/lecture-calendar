import React, { FC, useEffect, useState } from "react";
import { Button, Container, Grid, Typography } from "@mui/material";
import { ErrorBoundaryProps, FallbackProps, withErrorBoundary } from 'react-error-boundary'
import App from "../../App";
import { Image } from "@mui/icons-material";

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
        <Container>
            <Grid container
                  direction="column"
                  spacing={4}
                  justifyContent="center"
                  alignItems="center" sx={{minHeight: "50%"}}>
                <img src="https://cdn.dribbble.com/users/285475/screenshots/2083086/media/bbcfd1a1fecd97c1835792283a601f10.gif" alt={error?.name}/>
                <Typography variant="h2">
                    Ein Fehler ist aufgetreten:
                </Typography>
                <Typography variant={"h6"}>
                    Fehler:
                </Typography>
                {error?.stack?.split('\n').map(l => (<Typography sx={{maxWidth: "80%"}}>
                    {l}
                </Typography>))}
                <Button variant={"outlined"} onClick={resetErrorBoundary}>Ok</Button>
            </Grid>
        </Container>
    )
}
