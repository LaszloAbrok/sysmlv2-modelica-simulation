package PlatformIdependentModelExampleNonLinearResistor {
    private import ISQ::**;
    private import SI::**;
    private import ScalarValues::**;

    port def ElectricalPort{
        attribute voltage : ElectricPotentialValue;
        attribute current : ElectricCurrentValue;

    }

    part def NonLinearResistor {
        attribute R : ResistanceValue; // base resistance
        attribute k : Real; // nonlinearity factor

        // inner variable of voltage
        attribute v : ElectricPotentialValue;

        port p : ElectricalPort;
        port n : ElectricalPort;
    }
}