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
import { axiosInstance } from '../../../utils/axiosInstance'
import { fetchLectures } from '../../../services/LectureService'
import { Lecture } from '../../../models/lecture'
import { LectureDialog } from './LectureDialog'
import AddIcon from '@mui/icons-material/Add'

interface ComponentProps{

}

export const LectureList:FC<ComponentProps> = (props) => {
    const [expanded, setExpanded] = useState('')
    const [isDialogOpen, setIsDialogOpen] = useState(false);
    const [selectedLecture, setSelectedLecture] = useState<Lecture|null>(null);


    const handleExpanded = (name: string) => {
        if (name === expanded) {
            setExpanded('')
        } else {
            setExpanded(name)
        }
    }

    const lectureQuery = useQuery({
        queryKey: ['lectures'],
        queryFn: fetchLectures,
    })

    const deleteLecture = useMutation({
        mutationFn: (lectureId: string) => {
            return axiosInstance.delete(`Lecture/${lectureId}`)
        },
        onSuccess: (data) => {
            lectureQuery.refetch()
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
                
                <Button variant="outlined" startIcon={<AddIcon />} onClick= {()=> {setSelectedLecture(null); setIsDialogOpen(true)}}>Vorlesung hinzufügen</Button>
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
                                            onClick={() =>
                                                deleteLecture.mutate(
                                                    lecture.id!
                                                )
                                            }
                                        >
                                            <DeleteIcon />
                                        </IconButton>
                                    }
                                    onClick={() => {setIsDialogOpen(true); setSelectedLecture(lecture)}}
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
                currentLecture={selectedLecture}
        />
        </>
    )
}
