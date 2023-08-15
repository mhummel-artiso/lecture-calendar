import React, { FC } from "react";
import { TextFieldViewType } from "../EventDialog";
import {
    Accordion,
    AccordionDetails,
    AccordionSummary,
    Box,
    Button, Grid,
    IconButton,
    Stack,
    Typography
} from "@mui/material";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import { LayoutDisplayItem } from "../DialogInterfaces";
import DeleteIcon from "@mui/icons-material/Delete";
import { useAccount } from "../../../hooks/useAccount";


interface AccordionLayoutProps {
    sections: LayoutDisplayItem[]
    onDelete: () => void
    onCancel: () => void
    onUpdate: () => void
    canUpdate: boolean
}

export const AccordionLayout: FC<AccordionLayoutProps> = ({
                                                              sections,
                                                              onUpdate,
                                                              onCancel,
                                                              onDelete,
                                                              canUpdate
                                                          }) => {
    const {canEdit} = useAccount();
    const [expanded, setExpanded] = React.useState<string | boolean>('required');
    const handleChange = (panel: string) => (event: React.SyntheticEvent, isExpanded: boolean) => {
        setExpanded(isExpanded ? panel : false);
    }

    return (<Stack spacing={1}>
        <Box>
            {sections.map((x) => (
                <Accordion key={x.key} expanded={expanded === x.key} onChange={handleChange(x.key)}>
                    <AccordionSummary expandIcon={<ExpandMoreIcon/>}>
                        <Typography>{x.lable}</Typography>
                    </AccordionSummary>
                    <AccordionDetails>
                        {x.renderComponent}
                    </AccordionDetails>
                </Accordion>))}
        </Box>
        <Grid container direction={"row-reverse"} spacing={1}>
            {canEdit && (
                <Grid item>
                    <Button
                        onClick={onUpdate}
                        disabled={!canUpdate}
                        variant="contained">
                        Bearbeiten</Button>
                </Grid>
            )}
            <Grid item>
                <Button variant="outlined"
                        onClick={onCancel}>
                    {canEdit ? "Abbrechen" : "Schließen"}
                </Button>
            </Grid>
            {canEdit && (
                <Grid item>
                    <IconButton edge="end"
                                aria-label="delete"
                                onClick={(e) => {
                                    e.stopPropagation();
                                    onDelete();
                                }}
                                color="error"
                    >
                        <DeleteIcon/>
                    </IconButton>
                </Grid>)}
        </Grid>
    </Stack>);
}