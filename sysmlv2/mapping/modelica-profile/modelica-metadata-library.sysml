package ModelicaMetadataLibrary {
    private import ScalarValues::*;

    // doc todo

    enum def ModelicaComponentKind {
        model;
        block;
        record;
        connector;
        // package; - already in SysMLv2, need something new
        function;
    }

    metadata def ModelicaMappingMetadata {
        // Constrained only to parts. Might is extened it?
        :> annotatedElement : SysML::PartUsage;

        attribute path : String [0..1];
        attribute isCustom : Boolean;
        attribute componentType : ModelicaComponentKind;
    }

    doc /* * DAEs. Can only be used on ConstraintUsages.
     */
    metadata def ModelicaEquationMetadata {
        :> annotatedElement : SysML::ConstraintUsage;
        attribute equationString : String;   
    }

    doc /* * To define algorithms.
     */
     // For example: TMR voter
    metadata def ModelicaAlgorithmMetadata {
        :> annotatedElement : SysML::ConstraintUsage;
        attribute algorithmString : String;    
    }

    doc /* * Variable level metadata. Can only be added to attributes.
        isFlow attribute is set to true only when used for acausal physical interfaces.
        The isParameter flag distinguish between physical signals that changes over time from the configuration values
        that remain constant over time.

        For instance:
        A boolean port is not 
     */
    metadata def ModelicaVariableMetadata {
        :> annotatedElement : SysML::AttributeUsage;
        attribute isFlow : Boolean;
        attribute isParameter : Boolean;
    }
}