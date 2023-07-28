import {
    Accordion,
    AccordionDetails,
    AccordionSummary,
    Avatar,
    Box,
    Grid,
    IconButton,
    List,
    ListItem,
    ListItemAvatar,
    ListItemText,
    Typography,
} from '@mui/material'
import { NavBar } from '../components/NavBar'
import React, { useState } from 'react'
import FolderIcon from '@mui/icons-material/Folder'
import DeleteIcon from '@mui/icons-material/Delete'
import ExpandMoreIcon from '@mui/icons-material/ExpandMore'
import {useQuery} from '@tanstack/react-query'
import { axiosInstance } from '../utils/axiosInstance'
import axios from 'axios'
import { Lecture } from '../models/lecture'

export const AdminPage = () => {
    const [expanded, setExpanded] = useState('')

    const handleExpanded = (name: string) => {
        if (name === expanded) {
            setExpanded('')
        } else {
            setExpanded(name)
        }
    }
    
    const fetchLectures = async (): Promise<Lecture[]> => {
        const response = await axiosInstance.get<Lecture[]>('Lecture')
        return Promise.resolve(response.data)
    }

    const { isLoading, data, isError, error, isFetching } = useQuery({
        queryKey: ['lectures'],
        queryFn: fetchLectures,
    })

    return (
        <Box
            sx={{ display: 'flex', flexDirection: 'column', flexGrow: 1 }}
            marginX={10}
            marginTop={4}
        >
            <Typography variant={'h4'}>Übersicht</Typography>
            <Grid container marginTop={4} sx={{ flexGrow: 1 }}>
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
                        <Accordion
                            expanded={expanded === 'calendar'}
                            onChange={() => handleExpanded('calendar')}
                        >
                            <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                                <Typography>Kalendar</Typography>
                            </AccordionSummary>
                            <AccordionDetails>
                                <List>
                                    {[...Array(5).keys()].map(
                                        (value, index, array) => {
                                            return (
                                                <ListItem
                                                    divider
                                                    key={index}
                                                    secondaryAction={
                                                        <IconButton
                                                            edge="end"
                                                            aria-label="delete"
                                                        >
                                                            <DeleteIcon />
                                                        </IconButton>
                                                    }
                                                >
                                                    <ListItemAvatar>
                                                        <Avatar>
                                                            <FolderIcon />
                                                        </Avatar>
                                                    </ListItemAvatar>
                                                    <ListItemText primary="Single-line item" />
                                                </ListItem>
                                            )
                                        }
                                    )}
                                </List>
                            </AccordionDetails>
                        </Accordion>
                        <Accordion
                            expanded={expanded === 'lecture'}
                            onChange={() => handleExpanded('lecture')}
                        >
                            <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                                <Typography>Fächer</Typography>
                            </AccordionSummary>
                            <AccordionDetails>
                                <List>
                                {data?.map((lecture, index) => {
                                    return (
                                        <ListItem
                                            divider
                                            key={index}
                                            secondaryAction={
                                                <IconButton
                                                    edge="end"
                                                    aria-label="delete"
                                                >
                                                    <DeleteIcon />
                                                </IconButton>
                                            }
                                        >
                                            <ListItemText primary={lecture.title}/>
                                        </ListItem>
                                    )
                                }
                                )}
                                </List>
                            </AccordionDetails>
                        </Accordion>
                    </Grid>
                </Grid>
                <Grid item md={4}>
                    <Typography variant={'h4'}>Details</Typography>
                </Grid>
            </Grid>
        </Box>
    )
}
