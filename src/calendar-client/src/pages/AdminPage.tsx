import {
    Box,
    Fab,
    Grid,
    Typography,
} from '@mui/material'
import React, { useState } from 'react'
import AddIcon from '@mui/icons-material/Add'
import { LectureDialog } from '../components/LectureDialog'
import { CalendarList } from '../components/CalendarList'
import { LectureList } from '../components/LectureList'


export const AdminPage = () => {
    const [isDialogOpen, setIsDialogOpen] = useState(false)
    const isEditor = true

    return (
        <Box
            sx={{ display: 'flex', flexDirection: 'column', flexGrow: 1 }}
            margin={5}
        >
            <Grid container spacing={2} sx={{ flexGrow: 1 }}>
                <Grid item md={8} sx={{ position: 'relative', flexGrow: 1 }}>
                    <Grid
                        sx={{
                            position: 'absolute',
                            overflowX: 'auto',
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                        }}
                    >
                    <CalendarList/>
                    <LectureList/>
                    </Grid>
                </Grid>
                <Grid item md={4}>
                    <Typography variant={'h4'}>Details</Typography>
                </Grid>
            </Grid>
            {isEditor && (
                <Fab
                    color="primary"
                    sx={{
                        position: 'absolute',
                        bottom: 0,
                        right: 0,
                        margin: 7,
                    }}
                    onClick={() => setIsDialogOpen(true)}
                >
                    <AddIcon />
                </Fab>
            )}
            <LectureDialog
                isDialogOpen={isDialogOpen}
                handleDialogClose={() => setIsDialogOpen(false)}
            />
        </Box>
    )
}
