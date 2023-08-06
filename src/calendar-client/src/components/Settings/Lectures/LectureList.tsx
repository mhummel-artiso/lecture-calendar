import {
    Accordion,
    AccordionDetails,
    AccordionSummary,
    Button,
    Fab,
    Grid,
    IconButton,
    List,
    ListItem,
    ListItemText,
    Typography,
} from '@mui/material'
import React, { FC, useState } from 'react'
import DeleteIcon from '@mui/icons-material/Delete'
import ExpandMoreIcon from '@mui/icons-material/ExpandMore'
import { useMutation, useQuery } from '@tanstack/react-query'
import { addLecture, deleteLecture, editLecture, getLectures } from '../../../services/LectureService'
import { Lecture } from '../../../models/lecture'
import { LectureDialog } from './LectureDialog'
import AddIcon from '@mui/icons-material/Add'

export const LectureList: FC = () => {
    const [expanded, setExpanded] = useState('')
    const [isDialogOpen, setIsDialogOpen] = useState(false);
    const [selectedLecture, setSelectedLecture] = useState<Lecture | null>(null);

    const handleExpanded = (name: string) => {
        if(name === expanded) {
            setExpanded('')
        } else {
            setExpanded(name)
        }
    }

    const lectureQuery = useQuery({
        queryKey: ['lectures'],
        queryFn: getLectures,
    })
    const addLectureMutation = useMutation({
        mutationFn: async (lecture: Lecture) => {
            return await addLecture(lecture)
        },
        onSuccess: async (data) => {
            await lectureQuery.refetch()
        },
    });
    const editLectureMutation = useMutation({
        mutationFn: async (lecture: Lecture) => {
            if(lecture.id) {
                return await editLecture(lecture.id, lecture)
            }
        },
        onSuccess: async (data) => {
            await lectureQuery.refetch()
        },
    });
    const deleteLectureMutation = useMutation({
        mutationFn: async (lectureId: string) => {
            return await deleteLecture(lectureId)
        },
        onSuccess: async (data) => {
            await lectureQuery.refetch()
        },
    })

    return (
        <>

            <Accordion
                expanded={expanded === 'lecture'}
                onChange={() => handleExpanded('lecture')}
            >
                <AccordionSummary expandIcon={<ExpandMoreIcon/>}>
                    <Grid>
                        <Typography>Fächer</Typography>
                    </Grid>
                </AccordionSummary>
                <AccordionDetails>

                    <Button variant="outlined" startIcon={<AddIcon/>} onClick={() => {
                        setSelectedLecture(null);
                        setIsDialogOpen(true)
                    }}>Vorlesung hinzufügen</Button>
                    <List>
                        {lectureQuery.data?.map(
                            (lecture, index) => {
                                return (
                                    <ListItem
                                        divider
                                        key={index}
                                        secondaryAction={
                                            <IconButton
                                                edge="end"
                                                aria-label="delete"
                                                onClick={(e) =>{
                                                    e.stopPropagation();
                                                    deleteLectureMutation.mutate(
                                                        lecture.id!
                                                    )
                                                }}
                                            >
                                                <DeleteIcon/>
                                            </IconButton>
                                        }
                                        onClick={() => {
                                            setIsDialogOpen(true);
                                            setSelectedLecture(lecture)
                                        }}
                                    >
                                        <ListItemText
                                            primary={lecture.title}
                                        />
                                    </ListItem>
                                )
                            }
                        )}
                    </List>
                </AccordionDetails>
            </Accordion>
            <LectureDialog
                isDialogOpen={isDialogOpen}
                handleDialogAbort={() => setIsDialogOpen(false)}
                currentValue={selectedLecture}
                handleDialogAdd={addLectureMutation.mutate}
                handleDialogEdit={editLectureMutation.mutate}
            />
        </>
    )
}
