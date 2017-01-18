%==========================================================================
%Returns a vector of threshold indices in the form of [FWE, FDR, unCorr,
%stat]. If the specified value is not in the results pack, 0 is returned in
%its place. This function takes in one input:
%
%thresholds - a list of threshold objects stored inside the NIDM-Results
%json
%
%Authors: Thomas Maullin, Camille Maumet
%==========================================================================

function result = getThresholdPositions(thresholds) 

    %Initialise the threshold positions to zero,
    FWE = 0;
    FDR = 0;
    unCorr = 0;
    stat = 0;
    
    %Look for each threshold type in the list.
    for i = 1:length(thresholds)
        if any(ismember(thresholds{i}.('x_type'), 'obo_FWERadjustedpvalue')) || any(ismember(thresholds{i}.('x_type'), 'obo:OBI_0001265'))
            FWE = i;
        end
        if any(ismember(thresholds{i}.('x_type'), 'obo_qvalue')) || any(ismember(thresholds{i}.('x_type'), 'obo:OBI_0001442'))
            FDR = i;
        end
        if any(ismember(thresholds{i}.('x_type'), 'nidm_PValueUncorrected'))
            unCorr = i;
        end
        if any(ismember(thresholds{i}.('x_type'), 'obo_statistic')) || any(ismember(thresholds{i}.('x_type'), 'obo:STATO_0000039'))
            stat = i;
        end
    end
    
    %Return the resultant array of positions.
    result = [FWE, FDR, unCorr, stat];
    
end

