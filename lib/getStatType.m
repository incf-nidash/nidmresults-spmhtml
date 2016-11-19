%==========================================================================
%Obtain what type of statistic the NIDM-Pack uses (i.e. 'T', 'F', 'Z', 'P'
%or 'X' as well as the statisticMaps objects stored inside the NIDM-Results
%pack. The function takes in one input:
%
%graph - the graph from inside an NIDM-Results json.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function [type, statisticMaps] = getStatType(graph)
    
    %Find the statistic type information.
    statisticMaps = searchforType('nidm_StatisticMap', graph);
    for i = 1:length(statisticMaps)
        if isfield(statisticMaps{i}, 'nidm_statisticType')
            statType = statisticMaps{i}.('nidm_statisticType').('x_id');
        end
    end
    
    %Work out which type is stored.
    if strcmp(statType, 'obo:STATO_0000176')
       type = 'T';
    elseif strcmp(statType, 'obo:STATO_0000030')
       type = 'X';
    elseif strcmp(statType, 'obo:STATO_0000378')
       type = 'Z';
    elseif strcmp(statType, 'obo:STATO_0000282')
       type = 'F';
    else
       type = 'P';
    end
    
end