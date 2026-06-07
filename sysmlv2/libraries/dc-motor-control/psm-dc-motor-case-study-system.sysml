package PSM_DCMotorSystem {

    private import PIM_DCMotorSystem::**;
    private import PSM_DCMotorDefinitions::**;
    private import PSM_DCMotorInstances::**;

    private import ModelicaMetadataLibrary::**;

    part def Modelica_SystemUnderStudy :> SystemUnderStudy, ModelicaElement {
        
        @ModelicaMappingMetadata {
            isCustom = true;
            componentType = ModelicaComponentKind::Model;
        }
        
        part ramp : Modelica_Ramp :>> SystemUnderStudy::ramp;
        part feedback : Modelica_Feedback :>> SystemUnderStudy::feedback;
        part pid : Modelica_PID :>> SystemUnderStudy::pid;
        part inductor : Modelica_Inductor :>> SystemUnderStudy::inductor;
        part emf : Modelica_EMF :>> SystemUnderStudy::emf;
        part ground : Modelica_Ground :>> SystemUnderStudy::ground;

        part medianVoter : Modelica_MedianVoter :>> SystemUnderStudy::medianVoter;
        part fDIMonitor1 : Modelica_FDIMonitor :>> SystemUnderStudy::fDIMonitor1;
        part fDIMonitor2 : Modelica_FDIMonitor :>> SystemUnderStudy::fDIMonitor2;
        part fDIMonitor3 : Modelica_FDIMonitor :>> SystemUnderStudy::fDIMonitor3;
        part systemMonitor : Modelica_SystemMonitor :>> SystemUnderStudy::systemMonitor;
        
        part amplifier :> Modelica_SignalVoltage_instance :>> SystemUnderStudy::amplifier;
        part resistor :> Modelica_Resistor_instance :>> SystemUnderStudy::resistor;
        part inertia :> Modelica_Inertia_instance :>> SystemUnderStudy::inertia;
        
        part speedSensor1 :> Modelica_SpeedSensor_instance :>> SystemUnderStudy::speedSensor1;
        part speedSensor2 :> Modelica_SpeedSensor_instance :>> SystemUnderStudy::speedSensor2;
        part speedSensor3 :> Modelica_SpeedSensor_instance :>> SystemUnderStudy::speedSensor3;

    }
}