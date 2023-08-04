import { Button, Grid, Typography } from '@mui/material'
import { useNavigate } from 'react-router-dom'

export const NotFoundPage = () => {
    const navigate = useNavigate()
    return (
        <Grid
            container
            direction="column"
            gap={4}
            alignItems="center"
            justifyContent="center"
            sx={{ minHeight: '100vh' }}
        >
            <Grid>
                <Typography variant="h4">
                    Seite konnte nicht gefunden werden. 🤔
                </Typography>
            </Grid>
            <Grid>
                <Button variant="outlined" onClick={() => navigate('/')}>
                    Zum Kalender
                </Button>
            </Grid>
        </Grid>
    )
}
