package PSM_DCMotorDefinitions {

    private import PIM_DCMotorCaseStudy::**;

    private import ScalarValues::**;
    private import SI::**;

    private import ModelicaMetadataLibrary::**;
    private import ModelicaLanguageLibrary::**;
    private import FailureInjectionLibrary::**;

    part def Modelica_Resistor :> ResistorComponent, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Model; }

        port p : ElectricalPin :>> ResistorComponent::p;
        port n : ElectricalPin :>> ResistorComponent::n;

        attribute v : Real;
        attribute i : Real;

        constraint simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "v = p.v - n.v;
                 0 = p.i + n.i;
                 i = p.i;
                 v = i * R_nom;";
            }
        }
    }

    part def Modelica_Ground :> GroundComponent, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Model; }
        
        port p : ElectricalPin :>> GroundComponent::p;
        
        constraint simulationEquations {
            @ModelicaEquationMetadata { :>> equationString = "p.v = 0.0;"; }
        }
    }

    part def Modelica_Inductor :> InductorComponent, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Model; }
        
        port p : ElectricalPin :>> InductorComponent::p;
        port n : ElectricalPin :>> InductorComponent::n;
        attribute v : Real;

        constraint simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "v = p.v - n.v;
                 p.i + n.i = 0;
                 v = L * der(p.i);";
            }
        }
    }

    part def Modelica_EMF :> EMFComponent, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Model; }
        
        port p : ElectricalPin :>> EMFComponent::p;
        port n : ElectricalPin :>> EMFComponent::n;
        port flange : RotationalFlange :>> EMFComponent::flange;

        attribute v : Real;
        attribute i : Real;
        attribute w : Real;

        constraint simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "v = p.v - n.v;
                 0 = p.i + n.i;
                 i = p.i;
                 w = der(flange.phi);
                 v = k * w;
                 flange.tau = -k * i;";
            }
        }
    }

    part def Modelica_Inertia :> InertiaComponent, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Model; }
        
        port flange_a : RotationalFlange :>> InertiaComponent::flange_a;
        port flange_b : RotationalFlange :>> InertiaComponent::flange_b;
        
        attribute phi : Real;
        attribute w : Real;

        constraint simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "phi = flange_a.phi;
                 phi = flange_b.phi;
                 w = der(phi);
                 J * der(w) = flange_a.tau + flange_b.tau;";
            }
        }
    }

    part def Modelica_SignalVoltage :> SignalVoltageComponent, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Model; }
        
        port p : ElectricalPin :>> SignalVoltageComponent::p;
        port n : ElectricalPin :>> SignalVoltageComponent::n;
        in port v : RealInputPort :>> SignalVoltageComponent::v;

        constraint simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "p.v - n.v = max(-vMax, min(vMax, v));
                 p.i + n.i = 0;";
            }
        }
    }

    part def Modelica_SpeedSensor :> SpeedSensorComponent, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Model; }
        
        port flange : RotationalFlange :>> SpeedSensorComponent::flange;
        out port w : RealOutputPort :>> SpeedSensorComponent::w;
        
        attribute w_ideal : Real;

        constraint simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "w_ideal = der(flange.phi);
                 flange.tau = 0;
                 w = w_ideal;";
            }
        }
    }

    part def Modelica_Ramp :> RampSource, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Model; }
        out port y : RealOutputPort :>> RampSource::y;

        constraint simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = "y = offset + (if time < startTime then 0 else if time < startTime + duration then (time - startTime)*height/duration else height);";
            }
        }
    }

    part def Modelica_Feedback :> FeedbackNode, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Model; }
        in port u1 : RealInputPort :>> FeedbackNode::u1;
        in port u2 : RealInputPort :>> FeedbackNode::u2;
        out port y : RealOutputPort :>> FeedbackNode::y;

        constraint simulationEquations {
            @ModelicaEquationMetadata { :>> equationString = "y = u1 - u2;"; }
        }
    }

    part def Modelica_PID :> PIDController, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Model; }
        in port u : RealInputPort :>> PIDController::u;
        out port y : RealOutputPort :>> PIDController::y;
        
        attribute I_term : Real default 0.0;
        attribute y_unlimited : Real;

        constraint simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "der(I_term) = u / Ti;
                 y_unlimited = k * (u + I_term + Td * der(u));
                 y = max(yMin, min(yMax, y_unlimited));";
            }
        }
    }

    part def Modelica_MedianVoter :> MedianVoterLogic, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Block; }
        in port u1 : RealInputPort :>> MedianVoterLogic::u1;
        in port u2 : RealInputPort :>> MedianVoterLogic::u2;
        in port u3 : RealInputPort :>> MedianVoterLogic::u3;
        out port y : RealOutputPort :>> MedianVoterLogic::y;

        constraint simulationEquations {
            @ModelicaAlgorithmMetadata {
                :>> algorithmString = "y = max(min(u1, u2), min(max(u1, u2), u3));";
            }
        }
    }

    part def Modelica_FDIMonitor :> FDIMonitorLogic, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Model; }
        in port w_sensor : RealInputPort :>> FDIMonitorLogic::w_sensor;
        in port w_voter : RealInputPort :>> FDIMonitorLogic::w_voter;
        out port residual : RealOutputPort :>> FDIMonitorLogic::residual;
        out port fault_detected : BooleanOutputPort :>> FDIMonitorLogic::fault_detected;
        
        attribute fault_timer : Real default 0.0;

        constraint simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "residual = abs(w_sensor - w_voter);
                 der(fault_timer) = if residual > threshold then 1.0 else if fault_timer > 0.0 then -5.0 else 0.0;
                 fault_detected = fault_timer >= confirmation_time;";
            }
        }
    }

    part def Modelica_SystemMonitor :> SystemMonitorLogic, ModelicaElement {
        @ModelicaMappingMetadata { isCustom = true; componentType = ModelicaComponentKind::Model; }
        in port fault1 : BooleanInputPort :>> SystemMonitorLogic::fault1;
        in port fault2 : BooleanInputPort :>> SystemMonitorLogic::fault2;
        in port fault3 : BooleanInputPort :>> SystemMonitorLogic::fault3;
        in port w_ref : RealInputPort :>> SystemMonitorLogic::w_ref;
        in port w_voter : RealInputPort :>> SystemMonitorLogic::w_voter;
        out port critical_failure : BooleanOutputPort :>> SystemMonitorLogic::critical_failure;

        attribute active_faults : Integer;
        attribute tracking_error : Real;
        attribute tracking_timer : Real default 0.0;
        attribute hardware_fault : Boolean;

        constraint simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "active_faults = (if fault1 then 1 else 0) + (if fault2 then 1 else 0) + (if fault3 then 1 else 0);
                 tracking_error = abs(w_ref - w_voter);
                 der(tracking_timer) = if (time > startup_mask_time and tracking_error > tracking_threshold) then 1.0 else if tracking_timer > 0.0 then -1.0 else 0.0;
                 hardware_fault = tracking_timer >= tracking_confirmation_time;
                 critical_failure = (active_faults >= 2) or hardware_fault;";
            }
        }
    }
}