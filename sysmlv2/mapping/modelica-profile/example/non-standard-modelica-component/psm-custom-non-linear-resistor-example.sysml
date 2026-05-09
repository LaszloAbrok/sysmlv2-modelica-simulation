package PlatformSpecificModelExampleNonLinearResistor {

    private import ModelicaLanguageLibrary::**;
    private import ModelicaMetadataLibrary::**;
    private import PlatformIdependentModelExampleNonLinearResistor::**;
    
    // adapter port
    port def MappedElectricalPort specializes ElectricalPort, ElectricalPin;

    part def MappedNonLinearResistor specializes NonLinearResistor, ModelicaBaseModel {
        
        @ModelicaMappingMetadata {
            :>> isCustom = true; 
            :>> componentType = ModelicaComponentKind::model; 
        }
        
        @ModelicaVariableMetadata { :>> isParameter = true; }
        attribute R :>> NonLinearResistor::R; 
        
        @ModelicaVariableMetadata { :>> isParameter = true; }
        attribute k :>> NonLinearResistor::k; 

        port p :>> NonLinearResistor::p : MappedElectricalPort;
        port n :>> NonLinearResistor::n : MappedElectricalPort;

        // dae
        constraint customPhysics{
            @ModelicaEquationMetadata {
                :>> equationString = 
                    "p.i + n.i = 0;\n" +             
                    "v = p.v - n.v;\n" +             
                    "v = R * p.i + k * (p.i ^ 2);";  
            }
        }
    }
}