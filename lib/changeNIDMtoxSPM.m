
function NxSPM = changeNIDMtoxSPM(json)
    
    graph = json.('@graph')
    NxSPM = struct
    
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
    %nidm - NOTE: In the standard format for the SPM file the MIP is 
    %derived from other fields and this field does not exist.
    
    nidmTemp = struct
    temp = searchforType('nidm_ExcursionSetMap', graph)
    temp = searchforID(temp{1}.nidm_hasMaximumIntensityProjection.('@id'),graph)
    nidmTemp.MIP = fullfile(json.filepath, temp.('prov:atLocation').('@value'))
    
    %===============================================
    
    NxSPM.title = titleTemp
    NxSPM.STAT = STATTemp
    NxSPM.STATstr = STATStrTemp
    NxSPM.nidm = nidmTemp
    %Number of contrast vectors, currently only working with one.
    NxSPM.Ic = 1
    %Currently cursor is not working - these variables are used by the
    %cursor. The below are just random values chosen so that the matrix
    %generated for the cursor is non-singular.
    NxSPM.DIM = [0; 0; 0]
    NxSPM.M = [1, 0, 0, 0; 1, 2, 3, 0; 1, 0, 0, 2; 0, 1, 0, 0]
    
end