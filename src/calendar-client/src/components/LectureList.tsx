import {
    Accordion,
    AccordionDetails,
    AccordionSummary,
    IconButton,
    List,
    ListItem,
    ListItemText,
    Typography,
} from '@mui/material'
import React, { useState } from 'react'
import DeleteIcon from '@mui/icons-material/Delete'
import ExpandMoreIcon from '@mui/icons-material/ExpandMore'
import { useMutation, useQuery } from '@tanstack/react-query'
import { axiosInstance } from '../utils/axiosInstance'
import { fetchLectures } from '../services/LectureService'

export const LectureList = () => {
    const [expanded, setExpanded] = useState('')

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
        <Accordion
            expanded={expanded === 'lecture'}
            onChange={() => handleExpanded('lecture')}
        >
            <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                <Typography>Fächer</Typography>
            </AccordionSummary>
            <AccordionDetails>
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
    )
}
