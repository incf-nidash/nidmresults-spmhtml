%==========================================================================
%Obtain what type of statistic the NIDM-Pack uses (i.e. 'T', 'F', 'Z', 'P'
%or 'X' as well as the statisticMaps objects stored inside the NIDM-Results
%pack. The function takes in one or three input:
%
%graph - the graph from inside an NIDM-Results json.
%exNo - If there are multiple excursion sets, the set number of interest.
%exLabels - the exLabels hashmap object.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function [type, statisticMaps] = getStatType(graph, exNo, exLabels)
    
    %Find the statistic type information.
    statisticMaps = searchforType('nidm_StatisticMap', graph);
    
    %If there are multiple contrasts, refine the search.
    if(nargin == 3)      
        counter = 1;
        resultant = {};
        %Work out which object belongs to which excursion set.
        for(i = 1:length(statisticMaps))
            if(any(ismember(exLabels(statisticMaps{i}.prov_wasGeneratedBy.x_id),exNo)))
                resultant{counter} = statisticMaps{i};
                counter = counter+1;
            end
        end
        statisticMaps = resultant;
    end
    
    for i = 1:length(statisticMaps)
        if isfield(statisticMaps{i}, 'nidm_statisticType') 
            anyStatType = statisticMaps{i}.('nidm_statisticType').('x_id');
            if ~strcmp(anyStatType, 'obo:STATO_0000376')
                statType = statisticMaps{i}.('nidm_statisticType').('x_id');
            end
        end
    end
    
    %Work out which type is stored.
    if strcmp(statType, 'obo:STATO_0000176')
       type = 'T';
    elseif strcmp(statType, 'obo:STATO_0000030')
       type = 'X';
    elseif strcmp(statType, 'obo:STATO_0000376')
       type = 'Z';
    elseif strcmp(statType, 'obo:STATO_0000282')
       type = 'F';
    else
       type = 'P';
    end
    
end