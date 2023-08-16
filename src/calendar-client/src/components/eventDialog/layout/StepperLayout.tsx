import React, { FC, useState } from "react";
import { Box, Button, Grid, Stack, Step, StepLabel, Stepper, Typography } from "@mui/material";
import { LayoutDisplayItem } from "../DialogInterfaces";

interface StepperLayoutProps {
    steps: LayoutDisplayItem[],
    onSubmit: () => void
    onCancel: () => void
}

export const StepperLayout: FC<StepperLayoutProps> = ({steps, onSubmit, onCancel}) => {
    const [activeStep, setActiveStep] = useState(0);
    const [completed, setCompleted] = useState<{
        [k: number]: boolean;
    }>({});

    const handleStep = (step: number) => () => {
        setActiveStep(step);
        const newCompleted = completed;
        for(let i = steps.length - 1; i >= step; i--) {
            newCompleted[i] = false
        }
        setCompleted(newCompleted)
    }
    const totalSteps = () => {
        return steps.length;
    };

    const isLastStep = () => {
        return activeStep === totalSteps() - 1;
    };
    const handleComplete = () => {
        const newCompleted = completed;
        setCompleted(prevState => {
            newCompleted[activeStep] = true
            return newCompleted
        });
        setActiveStep((prevActiveStep) => prevActiveStep + 1)
    }
    const singelStep = (x: LayoutDisplayItem, index: number) => {
        const lableProps: {
            optional?: React.ReactNode;
            error?: boolean;
        } = {};
        lableProps.error = index < activeStep && x.required && x.errorFn && x.errorFn();
        if(lableProps.error) {
            lableProps.optional = (
                <Typography variant="caption" color="error">
                    {steps[index].errorMassage}
                </Typography>
            )
        }

        return (
            <Step key={x.lable}
                  completed={completed[index]}
                  color={completed[index] ? "success" : undefined}>
                <StepLabel {...lableProps} onClick={handleStep(index)}>
                    {x.lable}
                </StepLabel>
            </Step>)
    }

    const canContinue = () => {
        const step = steps[activeStep];
        if(step.errorFn) {
            return step.errorFn()
        }
        return true;
    }

    return (<Stack spacing={1}>
            <Box>
                <Stepper nonLinear activeStep={activeStep}>
                    {steps.map(singelStep)}
                </Stepper>
            </Box>
            <Box>
                {steps[activeStep].renderComponent}
            </Box>
            <Grid container direction={"row-reverse"} spacing={2}>
                <Grid item>
                    <Button variant={"outlined"} onClick={onCancel}>Abbrechen</Button>
                </Grid>
                <Grid item>
                    {isLastStep() ? (
                        <Button onClick={onSubmit} disabled={!completed[0] && !completed[1]}
                                variant="contained">
                            Hinzufügen
                        </Button>
                    ) : (<Button onClick={handleComplete} variant={"outlined"} disabled={!canContinue()}>
                        Weiter
                    </Button>)}
                </Grid>
            </Grid>
        </Stack>
    )
}