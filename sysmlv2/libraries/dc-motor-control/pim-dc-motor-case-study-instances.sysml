package PIM_DCMotorInstances {
    
    private import ScalarValues::**;
    private import SI::**;
    private import FailureInjectionLibrary::**;
    private import PIM_DCMotorCaseStudy::**;
    
    part resistor_instance : ResistorComponent {
        attribute :>> R_nom = 1.0;

        occurrence resistanceFault : ResistanceChangeError subsets failureModes {
            
            calc startBehavior : StochasticBehavior {
                in p = 0.3;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 5.0;
                    :>> standardDeviation = 1.0;
                }
                bind targetAttribute = startTime;
            }

            calc durationBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 10.0;
                    :>> standardDeviation = 2.0;
                }
                bind targetAttribute = duration;
            }

            calc valueBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 5.0;
                    :>> standardDeviation = 0.5;
                }
                bind targetAttribute = fault_R;
            }
        }
    }

    part amplifier_instance : SignalVoltageComponent {
        attribute :>> vMax = 400.0;

        occurrence gainFault : VoltageGainError subsets failureModes {
            
            calc startBehavior : StochasticBehavior {
                in p = 0.2;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 8.0;
                    :>> standardDeviation = 1.5;
                }
                bind targetAttribute = startTime;
            }

            calc durationBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 10.0;
                    :>> standardDeviation = 1.0;
                }
                bind targetAttribute = duration;
            }

            calc factorBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 0.5;
                    :>> standardDeviation = 0.1;
                }
                bind targetAttribute = fault_gainFactor;
            }
        }
    }

    part inertia_instance : InertiaComponent {
        attribute :>> J = 0.05;

        occurrence loadFault : LoadTorqueDisturbance subsets failureModes {
            
            calc startBehavior : StochasticBehavior {
                in p = 0.4;
                in dist : NormalProbabilityDistribution {
                    :>> mean = 12.0;
                    :>> standardDeviation = 2.0;
                }
                bind targetAttribute = startTime;
            }

            calc durationBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : UniformProbabilityDistribution { // Itt egyenletes eloszlást is használhatunk!
                    :>> lowerBound = 5.0;
                    :>> upperBound = 15.0;
                }
                bind targetAttribute = duration;
            }

            calc torqueBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution {
                    :>> mean = -15.0;
                    :>> standardDeviation = 3.0;
                }
                bind targetAttribute = fault_loadTorque;
            }
        }
    }

part speedSensor_instance : SpeedSensorComponent {
        
        // gain
        occurrence gainError : GainError subsets failureModes {
            calc startBehavior : StochasticBehavior {
                in p = 0.4;
                in dist : NormalProbabilityDistribution { :>> mean = 7.0; :>> standardDeviation = 1.0; }
                bind targetAttribute = startTime;
            }
            calc factorBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution { :>> mean = 1.15; :>> standardDeviation = 0.05; }
                bind targetAttribute = gainFactor;
            }
            calc durationBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution { :>> mean = 10.0; :>> standardDeviation = 2.0; }
                bind targetAttribute = duration;
            }
        }

        // stuck
        occurrence stuckAtValueError : StuckAtError subsets failureModes {
            calc startBehavior : StochasticBehavior {
                in p = 0.4;
                in dist : NormalProbabilityDistribution { :>> mean = 15.0; :>> standardDeviation = 2.0; }
                bind targetAttribute = startTime;
            }
            calc valueBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution { :>> mean = 0.0; :>> standardDeviation = 0.1; } // A Modelicában 0.0 az alap
                bind targetAttribute = stuckValue;
            }
            calc durationBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution { :>> mean = 7.0; :>> standardDeviation = 1.0; }
                bind targetAttribute = duration;
            }
        }

        // osc
        occurrence oscError : OscillationError subsets failureModes {
            calc startBehavior : StochasticBehavior {
                in p = 0.3; // prob
                in dist : NormalProbabilityDistribution { :>> mean = 5.0; :>> standardDeviation = 1.5; }
                bind targetAttribute = startTime;
            }
            calc amplitudeBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution { :>> mean = 5.0; :>> standardDeviation = 0.5; }
                bind targetAttribute = amplitude;
            }
            calc frequencyBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution { :>> mean = 10.0; :>> standardDeviation = 1.0; }
                bind targetAttribute = frequency;
            }
            calc durationBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution { :>> mean = 8.0; :>> standardDeviation = 1.5; }
                bind targetAttribute = duration;
            }
        }

        // drift
        occurrence driftError : DriftError subsets failureModes {
            calc startBehavior : StochasticBehavior {
                in p = 0.3; // porb
                in dist : NormalProbabilityDistribution { :>> mean = 10.0; :>> standardDeviation = 2.0; }
                bind targetAttribute = startTime;
            }
            calc rateBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution { :>> mean = 2.0; :>> standardDeviation = 0.2; }
                bind targetAttribute = rate;
            }
            calc durationBehavior : StochasticBehavior {
                in p = 1.0;
                in dist : NormalProbabilityDistribution { :>> mean = 12.0; :>> standardDeviation = 2.5; }
                bind targetAttribute = duration;
            }
        }

        constraint faultExclusivity1 : Excludes {
            in faultA = gainError;
            in faultB = stuckAtValueError;
        }

        constraint faultExclusivity2 : Excludes {
            in faultA = oscError;
            in faultB = stuckAtValueError;
        }

        constraint faultExclusivity3 : Excludes {
            in faultA = driftError;
            in faultB = stuckAtValueError;
        }
    }
}