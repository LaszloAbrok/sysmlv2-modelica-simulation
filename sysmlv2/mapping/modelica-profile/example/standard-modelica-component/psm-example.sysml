package PlatformSpecificModelExample{
    private import PlatformIdependentModelExample::*;
    private import ModelicaLanguageLibrary::**;
    private import ModelicaMetadataLibrary::**;

    // dependency inversion with adapter RealInputPort
    port def MappedElectricalPort specializes ElectricalPort, ElectricalPin;

    part def MappedResistor specializes Resistor, MSC_Resistor {

        // states explicitly that they are merged
        attribute R :>> Resistor::resistance, MSC_Resistor::R;
        port p :>> Resistor::p, MSC_Resistor::p; : MappedElectricalPort;        
        port n :>> Resistor::n, MSC_Resistor::n; : MappedElectricalPort;
    }

    part def MappedGround specializes Ground, MSC_Ground {
        port p :>> Ground::p, MSC_Ground::p; : MappedElectricalPort;
        port n :>> Ground::n, MSC_Ground::n; : MappedElectricalPort;
    }

    part def MappedVoltageSource specializes VoltageSource, MSC_ConstantVoltage {
        attribute V :>> VoltageSource::voltage, MSC_ConstantVoltage::V;
        port p :>> VoltageSource::p, MSC_ConstantVoltage::p; : MappedElectricalPort;
        port n :>> VoltageSource::n, MSC_ConstantVoltage::n; : MappedElectricalPort;
    }

    part def MappedLogicalCircuit specializes LogicalCircuit, ModelicaBaseModel {
        part ground :>> ground : MappedGround;
        part resistor :>> resistor : MappedResistor;
        part source :>> source : MappedVoltageSource;

        // only for visualization purposes (Tom Sawyer is lazy :/)
        connection :>> source_to_resistor_connection connect source.p to resistor.p;
        connection :>> source_to_ground_connection connect source.n to ground.n;
        connection :>> resistor_to_ground_connection connect resistor.n to ground.p;
    }


}