package ModelicaLanguageLibrary {
    
    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    
    private import ModelicaMetadataLibrary::*; 

    // Interfaces
    package Interfaces {
        
        package AcausalInterfaces {
            
            port def ElectricalPin {
                attribute v : ElectricPotentialValue; 
                
                attribute i : ElectricCurrentValue {
                    @ModelicaVariableMetadata {
                        :>> kind = ModelicaVariableKind::Flow;
                    }
                }
            }

            port def RotationalFlange {
                attribute phi : PlaneAngleValue; 
                
                attribute tau : TorqueValue {
                    @ModelicaVariableMetadata {
                        :>> kind = ModelicaVariableKind::Flow;
                    }
                }
            }
        }

        package CausalInterfaces {
            
            port def RealInputPort {
                attribute signalValue : Real {
                    @ModelicaVariableMetadata {
                        :>> causality = ModelicaCausality::Input;
                    }
                }
            }

            port def RealOutputPort {
                attribute signalValue : Real {
                    @ModelicaVariableMetadata {
                        :>> causality = ModelicaCausality::Output;
                    }
                }
            }

            port def BooleanInputPort {
                attribute signalValue : Boolean {
                    @ModelicaVariableMetadata {
                        :>> causality = ModelicaCausality::Input;
                    }
                }
            }
            
            port def BooleanOutputPort {
                attribute signalValue : Boolean {
                    @ModelicaVariableMetadata {
                        :>> causality = ModelicaCausality::Output;
                    }
                }
            }
        }
    }

    // base classes
    package BaseClasses {
        
        part def ModelicaBaseModel :> ModelicaElement {
            @ModelicaMappingMetadata {
                path = "";
                isCustom = false;
                componentType = ModelicaComponentKind::Model;
            }
        }

        part def ModelicaBaseBlock :> ModelicaElement {
            @ModelicaMappingMetadata { 
                path = "";
                isCustom = false;
                componentType = ModelicaComponentKind::Block;
            }
        }
    }

    // Modelica standard components
    package ModelicaStandardComponents {
        
        private import Interfaces::AcausalInterfaces::*;
        private import BaseClasses::*;

        part def MSC_ConstantVoltage :> ModelicaBaseModel {
            @ModelicaMappingMetadata { 
                :>> path = "Modelica.Electrical.Analog.Sources.ConstantVoltage"; 
            }
            
            attribute V : Real {
                @ModelicaVariableMetadata { 
                    :>> variability = ModelicaVariability::Parameter; 
                }
            }
            
            port p : ElectricalPin;
            port n : ElectricalPin;
        }

        part def MSC_Resistor :> ModelicaBaseModel {
            @ModelicaMappingMetadata { 
                :>> path = "Modelica.Electrical.Analog.Basic.Resistor"; 
            }
            
            attribute R : Real {
                @ModelicaVariableMetadata { 
                    :>> variability = ModelicaVariability::Parameter; 
                }
            }
            
            port p : ElectricalPin;
            port n : ElectricalPin;
        }

        part def MSC_Ground :> ModelicaBaseModel {
            @ModelicaMappingMetadata { 
                :>> path = "Modelica.Electrical.Analog.Basic.Ground"; 
            }
            
            port p : ElectricalPin;
        }
    }
}