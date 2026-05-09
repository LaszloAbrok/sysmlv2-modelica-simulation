package ModelicaImplementation {

    private import PlatformIdependentModelExampleVoter::*;
    private import ModelicaMetadataLibrary::*;
    private import ModelicaLanguageLibrary::BaseClasses::ModelicaBaseBlock;

    part def MappedVoter specializes Voter, ModelicaBaseBlock {
        
        @ModelicaMappingMetadata {
            :>> isCustom = true;  
            :>> componentType = ModelicaComponentKind::block; 
        }

        port input1 :>> input1;
        port input2 :>> input2;
        port input3 :>> input3;
        port y :>> output;

        @ModelicaAlgorithmMetadata {
            :>> algorithmString = "y := max(min(input1, input2), min(max(input1, input2),input3));";
        }
        constraint voterAlgorithm; 
    }
}