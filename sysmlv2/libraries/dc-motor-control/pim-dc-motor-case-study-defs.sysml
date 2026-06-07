package PIM_DCMotorCaseStudy {
    
    private import ScalarValues::**;
    private import SI::**;
    private import FailureInjectionLibrary::**;

    // Interfaces used in the model

    port def ElectricalPort {
        attribute voltage : Real;
        attribute current : Real;
    }

    port def FlangePort {
        attribute phi : Real;
        attribute torque : Real;
    }

    port def RealSignalPort {
        attribute signal : Real;
    }

    port def BooleanSignalPort {
        attribute _state : Boolean;
    }

    // Failure modes

    occurrence def ResistanceChangeError :> FailureMode {
        :>> description = "Unexpected change in resistance value.";
        attribute fault_R : Real;
    }

    occurrence def VoltageGainError :> FailureMode {
        :>> description = "Gain distortion in the voltage amplifier.";
        attribute fault_gainFactor : Real;
    }

    occurrence def LoadTorqueDisturbance :> FailureMode {
        :>> description = "Unexpected external load torque.";
        attribute fault_loadTorque : Real;
    }

    part def ResistorComponent {
        port p : ElectricalPort;
        port n : ElectricalPort;
        
        attribute R_nom : Real default 1.0;
        
        occurrence failureModes : FailureMode[*];
    }

    part def GroundComponent {
        port p : ElectricalPort;
    }

    part def EMFComponent {
        port p : ElectricalPort;
        port n : ElectricalPort;
        port flange : FlangePort;
        
        attribute k : Real default 0.1;
    }

    part def InductorComponent {
        port p : ElectricalPort;
        port n : ElectricalPort;
        
        attribute L : Real default 0.01;
    }

    part def SignalVoltageComponent {
        port p : ElectricalPort;
        port n : ElectricalPort;
        in port v : RealSignalPort;
        
        attribute vMax : Real default 400.0;
        
        occurrence failureModes : FailureMode[*];
    }

    part def InertiaComponent {
        port flange_a : FlangePort;
        port flange_b : FlangePort;
        
        attribute J : Real default 0.05;
        
        occurrence failureModes : FailureMode[*];
    }

    part def RampSource {
        out port y : RealSignalPort;
        
        attribute height : Real default 100.0;
        attribute duration : Real default 0.3;
        attribute offset : Real default 0.0;
        attribute startTime : Real default 0.1;
    }

    part def FeedbackNode {
        in port u1 : RealSignalPort;
        in port u2 : RealSignalPort;
        out port y : RealSignalPort;
    }

    part def PIDController {
        in port u : RealSignalPort;
        out port y : RealSignalPort;
        
        attribute k : Real default 1.0;
        attribute Ti : Real default 1.0;
        attribute Td : Real default 0.1;
        attribute yMax : Real default 400.0;
        attribute yMin : Real default -400.0;
    }

    part def MedianVoterLogic {
        in port u1 : RealSignalPort;
        in port u2 : RealSignalPort;
        in port u3 : RealSignalPort;
        out port y : RealSignalPort;
    }

    part def FDIMonitorLogic {
        in port w_sensor : RealSignalPort;
        in port w_voter : RealSignalPort;
        
        out port residual : RealSignalPort;
        out port fault_detected : BooleanSignalPort;
        
        attribute threshold : Real default 2.0;
        attribute confirmation_time : Real default 0.05;
    }

    part def SystemMonitorLogic {
        in port fault1 : BooleanSignalPort;
        in port fault2 : BooleanSignalPort;
        in port fault3 : BooleanSignalPort;
        
        in port w_ref : RealSignalPort;
        in port w_voter : RealSignalPort;
        
        out port critical_failure : BooleanSignalPort;
        
        attribute tracking_threshold : Real default 10.0;
        attribute tracking_confirmation_time : Real default 0.05;
        attribute startup_mask_time : Real default 1.0;
    }


    occurrence def StuckAtError :> FailureMode {
        :>> description = "The sensor output is a fixed value.";
        attribute stuckValue : Real default 0.0;
    }

    occurrence def GainError :> FailureMode {
        :>> description = "A scaling or amplification error in the measurement.";
        attribute gainFactor : Real default 1.15;
    }

    occurrence def OscillationError :> FailureMode {
        :>> description = "Sinusoidal oscillation noise in the measurement.";
        attribute amplitude : Real default 5.0;
        attribute frequency : Real default 10.0;
    }

    occurrence def DriftError :> FailureMode {
        :>> description = "A continuous, linearly increasing offset.";
        attribute rate : Real default 2.0;
    }

    part def SpeedSensorComponent {
        port flange : FlangePort;
        out port w : RealSignalPort;
        
        occurrence failureModes : FailureMode[*];
    }
}