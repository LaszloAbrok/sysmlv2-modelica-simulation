package ModelicaMetadataLibrary {
    private import ScalarValues::*;

    // Modelica kinds   

    enum def ModelicaComponentKind {
        Model;
        Block;
        Record;
        Connector;
        Function;
    }

    enum def ModelicaVariability {
        Continuous; // basic, continous in time
        Discrete;   // even drivent
        Parameter;  // constant during simulation
        Constant;   // system wide fix constant
    }

    enum def ModelicaCausality {
        Internal;   // acausal, physical
        Input;      // casual input signal
        Output;     // casual output signal
    }

    enum def ModelicaVariableKind {
        Potential;  // identical at a node (Across variable, e.g., voltage)
        Flow;       // converges at a single point
        Stream;     // stream
    }

    part def ModelicaElement; // Common Modelica Element to use

    metadata def ModelicaMappingMetadata{
        :> annotatedElement : ModelicaElement;
        attribute path : String;
        attribute isCustom : Boolean;
        attribute componentType : ModelicaComponentKind;
    }

    doc /* equation strings to constraints */
    metadata def ModelicaEquationMetadata {
        :> annotatedElement : SysML::ConstraintUsage;
        attribute equationString : String;   
    }

    doc /* alogirthm string to constraints*/
    metadata def ModelicaAlgorithmMetadata {
        :> annotatedElement : SysML::ConstraintUsage;
        attribute algorithmString : String;    
    }

    doc /* variable level metadata */
    metadata def ModelicaVariableMetadata {
        :> annotatedElement : SysML::AttributeUsage;
        
        attribute variability : ModelicaVariability default ModelicaVariability::Parameter;
        attribute causality   : ModelicaCausality   default ModelicaCausality::Internal;
        attribute kind        : ModelicaVariableKind default ModelicaVariableKind::Potential;
    }
}