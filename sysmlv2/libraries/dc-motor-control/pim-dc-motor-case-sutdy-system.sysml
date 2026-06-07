package PIM_DCMotorSystem {
    
    private import PIM_DCMotorCaseStudy::**;
    private import PIM_DCMotorInstances::**;

    part def SystemUnderStudy {
        
        part ramp : RampSource {
            attribute :>> height = 100.0;
        }
        part feedback : FeedbackNode;
        part pid : PIDController {
            attribute :>> k = 5.0;
            attribute :>> Ti = 0.05;
        }
        part inductor : InductorComponent;
        part emf : EMFComponent;
        part ground : GroundComponent;

        part medianVoter : MedianVoterLogic;
        part fDIMonitor1 : FDIMonitorLogic;
        part fDIMonitor2 : FDIMonitorLogic;
        part fDIMonitor3 : FDIMonitorLogic;
        part systemMonitor : SystemMonitorLogic;
        
        part amplifier :> amplifier_instance;
        part resistor  :> resistor_instance;
        part inertia   :> inertia_instance;
        
        part speedSensor1 :> speedSensor_instance;
        part speedSensor2 :> speedSensor_instance;
        part speedSensor3 :> speedSensor_instance;

        connect ramp.y to feedback.u1;
        connect feedback.y to pid.u;
        connect pid.y to amplifier.v;
        
        connect amplifier.n to ground.p;
        connect amplifier.n to emf.n;
        connect amplifier.p to resistor.p;
        connect resistor.n to inductor.p;
        connect inductor.n to emf.p;
        
        connect emf.flange to inertia.flange_a;
        connect speedSensor1.flange to inertia.flange_b;
        connect speedSensor2.flange to inertia.flange_b;
        connect speedSensor3.flange to inertia.flange_b;
        
        connect speedSensor1.w to medianVoter.u3;
        connect speedSensor2.w to medianVoter.u2;
        connect speedSensor3.w to medianVoter.u1;
        
        connect speedSensor1.w to fDIMonitor1.w_sensor;
        connect speedSensor2.w to fDIMonitor2.w_sensor;
        connect speedSensor3.w to fDIMonitor3.w_sensor;
        
        connect medianVoter.y to feedback.u2;
        connect medianVoter.y to fDIMonitor1.w_voter;
        connect medianVoter.y to fDIMonitor2.w_voter;
        connect medianVoter.y to fDIMonitor3.w_voter;
        connect medianVoter.y to systemMonitor.w_voter;
        
        connect ramp.y to systemMonitor.w_ref;
        connect fDIMonitor1.fault_detected to systemMonitor.fault3;
        connect fDIMonitor2.fault_detected to systemMonitor.fault1;
        connect fDIMonitor3.fault_detected to systemMonitor.fault2;
    }
}