library package FailureInjectionLibrary{
    
    private import ScalarValues::**;
    private import ISQ::**;

    abstract attribute def ProbabilityDistribution;

    attribute def ExponentialPropabilityDistribution :> ProbabilityDistribution{
        attribute lambda : Real;
    }

    attribute def NormalProbabilityDistribution :> ProbabilityDistribution{
        attribute mean : Real;
        attribute standardDeviation : Real;
    }

    attribute def WeibullProbabilityDistribution :> ProbabilityDistribution{
        attribute shape : Real;
        attribute scale : Real;
    }

    attribute def UniformProbabilityDistribution :> ProbabilityDistribution{
        attribute lowerBound : Real;
        attribute upperBound : Real;
    
    }

    // orchestratior
    // attribute def StochasticMode{
    //    attribute distribution : ProbabilityDistribution;
    //    attribute occurrenceProbability : Real default 1.0;
    // }

    calc def StochasticBehavior {
        in attribute p : Real default 1.0;
        in attribute distribution : ProbabilityDistribution;
        out attribute targetAttribute : Real;
    }

    occurrence def FailureMode{
        attribute description: String;
        
        // attribute mode: StochasticMode;
        
        // left it for the simulation orchestrator
        attribute startTime : TimeValue;
        attribute duration : TimeValue;

        // changes in simulation time
        attribute isActive: Boolean;

        constraint activityLogic{
            doc /* Evaluated continuously during execution in the simulation platform. */
            isActive == (time >= startTime) and (time <= startTime + duration)
        }
    }

    constraint def Excludes{
        in faultA : FailureMode;
        in faultB : FailureMode;

        (faultA.startTime + faultA.duration < faultB.startTime) or
        (faultB.startTime + faultB.duration < faultA.startTime)
    }

    constraint def Requires {
        in dependent : FailureMode;
        in prerequisite : FailureMode;

        (dependent.startTime + dependent.duration >= prerequisite.startTime) and
            (prerequisite.startTime + prerequisite.duration >= dependent.startTime)
    }

}