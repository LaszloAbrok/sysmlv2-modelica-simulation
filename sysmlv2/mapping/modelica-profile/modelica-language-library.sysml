package ModelicaLanguageLibrary {
    private import ScalarValues::**;
    private import ISQ::**;
    private import SI::**;
    private import ModelicaMetadataLibrary::**;

    package Interfaces{
        
        package AcausalInterfaces{
            
            port def ElectricalPin {
                attribute v : ElectricPotentialValue; // potential
                attribute i : ElectricCurrentValue; // flow

                @ModelicaVariableMetadata {
                    :>> isFlow = true;
                    :>> isParameter = false;
                }
                
            }

            port def RotationalFlange {
                attribute phi : PlaneAngleValue; // potential
                attribute tau : TorqueValue; // flow

                @ModelicaVariableMetadata {
                    :>> isFlow = true;
                    :>> isParameter = false;
                }
            }

        }

        package CausalInterfaces{
            
            port def RealInputPort {
                attribute signalValue : Real;

                @ModelicaVariableMetadata {
                    :>> isFlow = false;
                    :>> isParameter = false;
                }
            }

            port def RealOutputPort {
                attribute signalValue : Real;

                @ModelicaVariableMetadata {
                    :>> isFlow = false;
                    :>> isParameter = false;
                }
            }

            port def BooleanInputPort {
                attribute signalValue : Boolean;
            
                @ModelicaVariableMetadata {
                    :>> isFlow = false;
                    :>> isParameter = false;
                }
            }
            
            port def BooleanOutputPort {
                attribute signalValue : Boolean;
                
                @ModelicaVariableMetadata {
                    :>> isFlow = false;
                    :>> isParameter = false;
                }
            }
        }

    }

    package BaseClasses{
        
        part def ModelicaBaseModel {
            @ModelicaMappingMetadata {
                :>> componentType = ModelicaComponentKind::model;
                :>> isCustom = false;
            }
        }

        part def ModelicaBaseBlock {
            @ModelicaMappingMetadata { 
                :>> componentType = ModelicaComponentKind::block;
                :>> isCustom = false;
            }
        }
    }

    package ModelicaStandardComponents{
        
        private import Interfaces::**;


        part def MSC_ConstantVoltage {
        
        @ModelicaMappingMetadata { :>> path = "Modelica.Electrical.Analog.Sources.ConstantVoltage"; }
        @ModelicaVariableMetadata { :>> isParameter = true; }
        
        attribute V : Real;
        port p : ElectricalPin;
        port n : ElectricalPin;
        
        }

        part def MSC_Resistor {
            
            @ModelicaMappingMetadata { :>> path = "Modelica.Electrical.Analog.Basic.Resistor"; }
            @ModelicaVariableMetadata { :>> isParameter = true; }
            
            attribute R : Real;
            port p : ElectricalPin;
            port n : ElectricalPin;
            
        }

        part def MSC_Ground {
            @ModelicaMappingMetadata { :>> path = "Modelica.Electrical.Analog.Basic.Ground"; }
            port p : ElectricalPin;
            port n : ElectricalPin;
        }
    }
}