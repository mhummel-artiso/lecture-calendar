import {
    Accordion,
    AccordionDetails,
    AccordionSummary,
    Box,
    Button,
    CircularProgress,
    Dialog,
    DialogContent,
    DialogTitle,
    Fab,
    Grid,
    IconButton,
    List,
    ListItem,
    ListItemButton,
    ListItemSecondaryAction,
    ListItemText,
    Typography,
} from '@mui/material'
import React, { FC, useEffect, useState } from 'react'
import DeleteIcon from '@mui/icons-material/Delete'
import ExpandMoreIcon from '@mui/icons-material/ExpandMore'
import { useMutation, useQuery } from '@tanstack/react-query'
import {
    addLecture,
    deleteLecture,
    editLecture,
    getLectures,
} from '../../../services/LectureService'
import { Lecture } from '../../../models/lecture'
import { LectureDialog } from './LectureDialog'
import AddIcon from '@mui/icons-material/Add'
import { AxiosErrorInformation } from '../../ErrorContent/AxiosErrorInformation'
import { AxiosError } from 'axios'

export const LectureList: FC = () => {
    const [expanded, setExpanded] = useState('')
    const [isDialogOpen, setIsDialogOpen] = useState(false)
    const [selectedLecture, setSelectedLecture] = useState<Lecture | null>(null)

    const handleExpanded = (name: string) => {
        if (name === expanded) {
            setExpanded('')
        } else {
            setExpanded(name)
        }
    }

    const { isLoading, data, refetch } = useQuery({
        queryKey: ['lectures'],
        queryFn: getLectures,
        useErrorBoundary: true,
    })

    const addLectureMutation = useMutation({
        mutationFn: async (lecture: Lecture) => {
            return await addLecture(lecture)
        },
        onSuccess: async (_) => {
            await refetch()
        },
    })

    const editLectureMutation = useMutation({
        mutationFn: async (lecture: Lecture) => {
            if (lecture.id) {
                return await editLecture(lecture.id, lecture)
            }
        },
        onSuccess: async (_) => {
            await refetch()
        },
    })

    const deleteLectureMutation = useMutation({
        mutationFn: async (lectureId: string) => {
            return await deleteLecture(lectureId)
        },
        onSuccess: async (data) => {
            await refetch()
        },
    })

    return (
        <>
            <Accordion
                expanded={expanded === 'lecture'}
                onChange={() => handleExpanded('lecture')}
            >
                <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                    <Grid>
                        <Typography>Fächer</Typography>
                    </Grid>
                </AccordionSummary>
                <AccordionDetails>
                    {isLoading ? (
                        <Box margin={1}>
                            <CircularProgress />
                        </Box>
                    ) : (
                        <>
                            <Button
                                variant="outlined"
                                startIcon={<AddIcon />}
                                onClick={() => {
                                    setSelectedLecture(null)
                                    setIsDialogOpen(true)
                                }}
                            >
                                Vorlesung hinzufügen
                            </Button>
                            <List>
                                {data?.map((lecture, index) => (
                                    <ListItemButton
                                        divider
                                        key={index}
                                        onClick={() => {
                                            setIsDialogOpen(true)
                                            setSelectedLecture(lecture)
                                        }}
                                    >
                                        <ListItemText primary={lecture.title} />
                                        <ListItemSecondaryAction>
                                            <IconButton
                                                edge="end"
                                                aria-label="delete"
                                                onClick={(e) => {
                                                    e.stopPropagation()
                                                    deleteLectureMutation.mutate(
                                                        lecture.id!
                                                    )
                                                }}
                                            >
                                                <DeleteIcon />
                                            </IconButton>
                                        </ListItemSecondaryAction>
                                    </ListItemButton>
                                ))}
                            </List>
                        </>
                    )}
                </AccordionDetails>
            </Accordion>
            <LectureDialog
                isDialogOpen={isDialogOpen}
                onDialogClose={() => setIsDialogOpen(false)}
                currentValue={selectedLecture}
                onDialogAdd={addLectureMutation.mutate}
                onDialogEdit={editLectureMutation.mutate}
            />
        </>
    )
}
