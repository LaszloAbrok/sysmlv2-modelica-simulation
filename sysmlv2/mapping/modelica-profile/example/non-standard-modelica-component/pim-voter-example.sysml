package PlatformIdependentModelExampleVoter{

    private import ScalarValues::**;
    private import ISQ::**;
    private import SI::**;

    port def RealInput {
        attribute signalValue : Real;
    }

    port def RealOutput {
        attribute signalValue : Real;
    }

    part def Voter{
        port input1 : RealInput;
        port input2 : RealInput;
        port input3 : RealInput;
        port output : RealOutput;
    }

}