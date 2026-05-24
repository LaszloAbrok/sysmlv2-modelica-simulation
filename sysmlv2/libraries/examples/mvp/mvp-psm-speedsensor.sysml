package PSM_MVP_SpeedSensor{

    private import PIM_MVP_SpeedSensor::**;

    private import ScalarValues::**;
    private import SI::**;

    private import ModelicaMetadataLibrary::**;
    private import ModelicaLanguageLibrary::**;
    private import FailureInjectionLibrary::**;

    part def Modelica_SpeedSensor :> RotationalSpeedSensor, ModelicaElement {
        
        @ModelicaMappingMetadata {
            isCustom = true;
            componentType = ModelicaComponentKind::Model;
        }

        port flange : RotationalFlange :>> RotationalSpeedSensor::flange;
        out port w : RealOutputPort :>> RotationalSpeedSensor::w;

        attribute w_nom : Real;
        
        constraint simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "
                w_ideal = der(flange.phi);
                flange.tau = 0.0;
                w_out.signal = w_ideal;
                ";
            }
        }
    }

    part Modelica_SpeedSensor_instance : Modelica_SpeedSensor :> SensorUnderStudy{
        constraint :>> simulationEquations {
            @ModelicaEquationMetadata {
                :>> equationString = 
                "w_ideal = der(flange.phi);
                 flange.tau = 0.0;
                 
                 w_out.signalValue = 
                    if stuckAtValueError.isActive then stuckAtValueError.stuckValue
                    else if gainError.isActive then w_ideal * gainError.gainFactor
                    else w_ideal;";
            }
        }

        
        attribute :>> gainError.gainFactor {
            @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; }
        }
        attribute :>> gainError.startTime {
            @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; }
        }
        attribute :>> gainError.duration {
            @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; }
        }

        attribute :>> stuckAtValueError.value {
            @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; }
        }
        attribute :>> stuckAtValueError.startTime {
            @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; }
        }
        attribute :>> stuckAtValueError.duration {
            @ModelicaVariableMetadata { variability = ModelicaVariability::Parameter; }
        }

    }
}