%Returns a vector of threshold indices in the form of [FWE, FDR, unCorr,
%stat]. If the specified value is not in the results pack, 0 is returned in
%its place.

function result = getThresholdPositions(thresholds) 
    FWE = 0;
    FDR = 0;
    unCorr = 0;
    stat = 0;
    for i = 1:length(thresholds)
        if any(ismember(thresholds{i}.('@type'), 'obo_FWERadjustedpvalue'))
            FWE = i;
        end
        if any(ismember(thresholds{i}.('@type'), 'obo_FDRadjustedqvalue'))
            FDR = i;
        end
        if any(ismember(thresholds{i}.('@type'), 'nidm_PValueUncorrected'))
            unCorr = i;
        end
        if any(ismember(thresholds{i}.('@type'), 'obo_statistic'))
            stat = i;
        end
    end
    result = [FWE, FDR, unCorr, stat];
end

