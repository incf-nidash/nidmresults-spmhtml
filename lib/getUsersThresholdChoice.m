%==========================================================================
%Returns a vector of the users input threshold choice from when the 
%NIDM-Results pack was generated and its value. It takes in one input:
%
%thresholds - a list of threshold objects stored inside the NIDM-Results
%json
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function [type, value] = getUsersThresholdChoice(thresholds)

    %Find the location of the nidm_equivalentTheshold object.
    pos = 0;
    for i = 1:length(thresholds)
        if isfield(thresholds{i}, 'nidm_equivalentThreshold')
            pos = i;
        end
    end
    
    %Obtain the value.
    if isfield(thresholds{pos}, 'nidm_clusterSizeInVoxels')
        value = thresholds{pos}.('nidm_clusterSizeInVoxels').('x_value');
    end
    if isfield(thresholds{pos}, 'prov_value')
        value = thresholds{pos}.('prov_value').('x_value');
    end
    
    %Obtain it's type.
    if any(ismember(thresholds{pos}.('x_type'), 'obo_FWERadjustedpvalue'))
        type = 'FWE';
    end
    if any(ismember(thresholds{pos}.('x_type'), 'obo_FDRadjustedqvalue'))
        type = 'FDR';
    end
    if any(ismember(thresholds{pos}.('x_type'), 'nidm_PValueUncorrected'))
        type = 'unCorr';
    end
    if any(ismember(thresholds{pos}.('x_type'), 'obo_statistic'))
        type = 'stat';
    end
    
end