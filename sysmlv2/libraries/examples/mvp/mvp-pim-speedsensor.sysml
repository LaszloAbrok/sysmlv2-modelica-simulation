package PIM_MVP_SpeedSensor{
    
    private import ScalarValues::**;
    private import SI::**;
    private import FailureInjectionLibrary::**;


    port def FlangePort{
        attribute phi : Real;
        attribute torque : Real;
    }

    port def SignalPort{
        attribute signal : Real;
    }

    // failure definitions


    occurrence def GainError :> FailureMode{
        :>> description = "Scaling error in the measurement.";
        attribute gainFactor : Real;
    }

    occurrence def StuckAtValueError :> FailureMode{
        :>> description = "Sensor outputs only a constant value.";
        attribute value : Real;
    }

    // part definition

    part def RotationalSpeedSensor{
        port flange : FlangePort;
        out port w : SignalPort;
        occurrence failureModes : FailureMode[*];
    }


    part SensorUnderStudy: RotationalSpeedSensor{
        

        occurrence gainError : GainError subsets failureModes{

            calc startBehavior : StochasticBehavior {
                in p = 0.4;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 7.0;
                    :>> standardDeviation = 1.0;
                }
                bind targetAttribute = startTime;
            }

            calc factorBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 1.15;
                    :>> standardDeviation = 0.05;
                }
                bind targetAttribute = gainFactor;
            }

            calc durationBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 10.0;
                    :>> standardDeviation = 2.0;
                }
                bind targetAttribute = duration;
            }
        }

       occurrence stuckAtValueError : StuckAtValueError subsets failureModes{


            calc startBehavior : StochasticBehavior {
                in p = 0.4;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 15.0;
                    :>> standardDeviation = 2.0;
                }
                bind targetAttribute = startTime;
            }

            calc valueBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 0.3;
                    :>> standardDeviation = 0.05;
                }
                bind targetAttribute = value;
            }

            calc durationBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 7.0;
                    :>> standardDeviation = 1.0;
                }
                bind targetAttribute = duration;
            }
        }

        constraint gainExcludesStuckAtValue : Excludes{
            in faultA = gainError;
            in faultB = stuckAtValueError;
        }

    }
}