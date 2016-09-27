%Returns a vector of the users input threshold choice and its value.

function [type, value] = getUsersThresholdChoice(thresholds)
    temp = 0
    for i = 1:length(thresholds)
        if isfield(thresholds{i}, 'nidm_equivalentThreshold')
            temp = i
        end
    end
    if isfield(thresholds{temp}, 'nidm_clusterSizeInVoxels')
        value = thresholds{temp}.('nidm_clusterSizeInVoxels').('@value')
    end
    if isfield(thresholds{temp}, 'prov:value')
        value = thresholds{temp}.('prov:value').('@value')
    end
    if any(ismember(thresholds{temp}.('@type'), 'obo_FWERadjustedpvalue'))
        type = 'FWE'
    end
    if any(ismember(thresholds{temp}.('@type'), 'obo_FDRadjustedqvalue'))
        type = 'FDR'
    end
    if any(ismember(thresholds{temp}.('@type'), 'nidm_PValueUncorrected'))
        type = 'unCorr'
    end
    if any(ismember(thresholds{temp}.('@type'), 'obo_statistic'))
        type = 'stat'
    end
end