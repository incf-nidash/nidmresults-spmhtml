
function NxSPM = changeNIDMtoxSPM(xSPM, json)
    
    graph = json.('@graph')
    NxSPM = xSPM
    
    %==============================================
    %title
    
    temp = searchforType('nidm_ContrastMap', graph)
    for i = 1:length(temp)
        if isfield(temp{i}, 'nidm_contrastName')
            titleTemp = temp{i}.('nidm_contrastName')
        end
    end 
    
    %==============================================
    %STAT
    
    temp = searchforType('nidm_StatisticMap', graph)
    for i = 1:length(temp)
        if isfield(temp{i}, 'nidm_statisticType')
            statType = temp{i}.('nidm_statisticType').('@id')
        end
    end
    
    if strcmp(statType, 'obo:STATO_0000176')
       STATTemp = 'T'
    elseif strcmp(statType, 'obo:STATO_0000030')
       STATTemp = 'X'
    elseif strcmp(statType, 'obo:STATO_0000378')
       STATTemp = 'Z'
    elseif strcmp(statType, 'obo:STATO_0000282')
       STATTemp = 'F'
    else
       STATTemp = 'P'
    end
       
    %===============================================
    %STATStr
    
    temp = searchforType('nidm_StatisticMap', graph)
    for i = 1:length(temp)
        if isfield(temp{i}, 'nidm_errorDegreesOfFreedom')
            errorDegrees = temp{i}.('nidm_errorDegreesOfFreedom').('@value')
        end
    end 
    errorDegrees = num2str(round(str2num(errorDegrees)))
    STATStrTemp = [STATTemp '_{' errorDegrees '}']
    
    %===============================================
    
    NxSPM.title = titleTemp
    NxSPM.STAT = STATTemp
    NxSPM.STATStr = STATStrTemp
    
end