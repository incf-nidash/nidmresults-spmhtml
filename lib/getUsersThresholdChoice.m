%Returns a vector of the users input threshold choice and its value.

function [type, value] = getUsersThresholdChoice(thresholds)
    pos = 0
    for i = 1:length(thresholds)
        if isfield(thresholds{i}, 'nidm_equivalentThreshold')
            pos = i
        end
    end
    if isfield(thresholds{pos}, 'nidm_clusterSizeInVoxels')
        value = thresholds{pos}.('nidm_clusterSizeInVoxels').('@value')
    end
    if isfield(thresholds{pos}, 'prov:value')
        value = thresholds{pos}.('prov:value').('@value')
    end
    if any(ismember(thresholds{pos}.('@type'), 'obo_FWERadjustedpvalue'))
        type = 'FWE'
    end
    if any(ismember(thresholds{pos}.('@type'), 'obo_FDRadjustedqvalue'))
        type = 'FDR'
    end
    if any(ismember(thresholds{pos}.('@type'), 'nidm_PValueUncorrected'))
        type = 'unCorr'
    end
    if any(ismember(thresholds{pos}.('@type'), 'obo_statistic'))
        type = 'stat'
    end
end