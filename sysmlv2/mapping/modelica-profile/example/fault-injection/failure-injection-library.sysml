library package FailureInjectionLibrary{
    
    private import ScalarValues::**;
    private import ISQ::**;

    enum def DistributinType{
        Deterministic; // occurs in fix timepoint
        Uniform; // unifomr distribution in a timewindow
        Normal; // normal distribution in a timewindow
        Exponential; // exponential distribution in a timewindow
        Poisson; // poisson distribution in a timewindow
    }

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

    // orchestratior??
    attribute def StochasticMode{
        attribute distribution : ProbabilityDistribution;
        attribute occurrenceProbability : Real default 1.0;
    }

    occurrence def FailureMode{
        attribute description: String;
        
        attribute mode: StochasticMode;
        
        // simulation (Monte-Carlo???)
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