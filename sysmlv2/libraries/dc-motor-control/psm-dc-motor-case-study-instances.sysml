package PSM_DCMotorInstances {

    private import PIM_DCMotorCaseStudy::**;
    private import PIM_DCMotorInstances::**;
    private import PSM_DCMotorDefinitions::**;

    private import ModelicaMetadataLibrary::**;
    private import FailureInjectionLibrary::**;

    private import ScalarValues::**;


    part Modelica_Resistor_instance : Modelica_Resistor :> resistor_instance {
        
        attribute R_actual : Real;

        constraint :>> simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "v = p.v - n.v;
                0 = p.i + n.i;
                i = p.i;
                R_actual = if (time >= fault_startTime and time <= fault_startTime + fault_duration) then fault_R else R_nom;
                v = i * R_actual;"; 
            }
        }

        attribute :>> resistanceFault.fault_R { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
        attribute :>> resistanceFault.startTime { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
        attribute :>> resistanceFault.duration { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
    }

    part Modelica_SignalVoltage_instance : Modelica_SignalVoltage :> amplifier_instance {
        
        attribute v_actual : Real;
        attribute v_faulty : Real;

        constraint :>> simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "v_faulty = if gainFault.isActive then v.signal * gainFault.fault_gainFactor else v.signal;
                 v_actual = max(-vMax, min(vMax, v_faulty));
                 p.v - n.v = v_actual;
                 p.i + n.i = 0;";
            }
        }

        attribute :>> gainFault.fault_gainFactor { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
        attribute :>> gainFault.startTime { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
        attribute :>> gainFault.duration { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
    }

    part Modelica_Inertia_instance : Modelica_Inertia :> inertia_instance {
        
        attribute tau_dist : Real;

        constraint :>> simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "phi = flange_a.phi;
                 phi = flange_b.phi;
                 w = der(phi);
                 tau_dist = if loadFault.isActive then loadFault.fault_loadTorque else 0.0;
                 J * der(w) = flange_atau + flange_b.tau + tau_dist;";
            }
        }

        attribute :>> loadFault.fault_loadTorque { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
        attribute :>> loadFault.startTime { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
        attribute :>> loadFault.duration { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
    }

    part Modelica_SpeedSensor_instance : Modelica_SpeedSensor :> speedSensor_instance {
        
        constraint :>> simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "  w_ideal = der(flange.phi);
                    flange.tau = 0;

                    w_drifted = w_ideal + (if driftError_isActive then driftError_rate * (time - driftError_startTime) else 0.0);
                    w_gained = w_drifted * (if gainError_isActive then gainError_gainFactor else 1.0);
                    w_oscillated = w_gained + (if oscError_isActive then oscError_amplitude*sin(2*Modelica.Constants.pi*oscError_frequency*(time - oscError_startTime)) else 0.0);
                    w = if stuckError_isActive then stuckError_value else w_oscillated;";
            }
        }
        
        attribute :>> gainError.gainFactor { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
        attribute :>> gainError.startTime { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
        attribute :>> gainError.duration { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }

        attribute :>> stuckAtValueError.stuckValue { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
        attribute :>> stuckAtValueError.startTime { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
        attribute :>> stuckAtValueError.duration { @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; } }
    }
}