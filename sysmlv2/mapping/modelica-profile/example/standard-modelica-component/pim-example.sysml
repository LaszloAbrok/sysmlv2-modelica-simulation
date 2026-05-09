package PlatformIdependentModelExample{
    
    private import ISQ::*;
    private import SI::*;
    private import ScalarValues::*;
    
    port def ElectricalPort{
        attribute voltage : ElectricPotentialValue;
        attribute current : ElectricCurrentValue;

    }

    part def Resistor{
        attribute resistance : ResistanceValue;
        port p : ElectricalPort;
        port n : ElectricalPort;
    }

    part def VoltageSource{
        attribute voltage : ElectricPotentialValue;
        port p : ElectricalPort;
        port n : ElectricalPort;
    }

    part def Ground{
        port p : ElectricalPort;
        port n : ElectricalPort;
    }

    part def LogicalCircuit{
        part ground : Ground;
        
        part resistor : Resistor{
            attribute :>> resistance = 10.0 [ohm];
        }

        part source : VoltageSource{
            attribute :>> voltage = 10.0 [V];
        }

        connection source_to_resistor_connection connect source.p to resistor.p;
        connection source_to_ground_connection connect source.n to ground.n;
        connection resistor_to_ground_connection connect resistor.n to ground.p;

    }

}