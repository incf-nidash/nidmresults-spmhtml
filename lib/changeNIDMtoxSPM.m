
function NxSPM = changeNIDMtoxSPM(json)
    
    graph = json.('x_graph');
    NxSPM = struct;
    
    %==============================================
    %title
    
    contrastMaps = searchforType('nidm_ContrastMap', graph);
    for i = 1:length(contrastMaps)
        if isfield(contrastMaps{i}, 'nidm_contrastName')
            titleTemp = contrastMaps{i}.('nidm_contrastName');
        end
    end 
    
    %==============================================
    %STAT
    
    statisticMaps = searchforType('nidm_StatisticMap', graph);
    for i = 1:length(statisticMaps)
        if isfield(statisticMaps{i}, 'nidm_statisticType')
            statType = statisticMaps{i}.('nidm_statisticType').('x_id');
        end
    end
    
    if strcmp(statType, 'obo:STATO_0000176')
       STATTemp = 'T';
    elseif strcmp(statType, 'obo:STATO_0000030')
       STATTemp = 'X';
    elseif strcmp(statType, 'obo:STATO_0000378')
       STATTemp = 'Z';
    elseif strcmp(statType, 'obo:STATO_0000282')
       STATTemp = 'F';
    else
       STATTemp = 'P';
    end
       
    %===============================================
    %STATStr
    
    for i = 1:length(statisticMaps)
        if isfield(statisticMaps{i}, 'nidm_errorDegreesOfFreedom')
            errorDegrees = statisticMaps{i}.('nidm_errorDegreesOfFreedom').('x_value');
        end
    end 
    errorDegrees = num2str(round(str2num(errorDegrees)));
    STATStrTemp = [STATTemp '_{' errorDegrees '}'];
    
    %===============================================
    %nidm - NOTE: In the standard format for the SPM file the MIP is 
    %derived from other fields and this field does not exist.
    
    nidmTemp = struct;
    excursionSetMaps = searchforType('nidm_ExcursionSetMap', graph);
    mipFilepath = searchforID(excursionSetMaps{1}.nidm_hasMaximumIntensityProjection.('x_id'),graph);
    nidmTemp.MIP = fullfile(json.filepath, mipFilepath.('prov_atLocation').('x_value'));
    
    %===============================================
    %M
    
    coordSpaceId = excursionSetMaps{1}.('nidm_inCoordinateSpace').('x_id');
    coordSpace = searchforID(coordSpaceId, graph);
    v2wm = str2num(strrep(coordSpace.nidm_voxelToWorldMapping, '],[', '; '));
    transform = [1, 0, 0, -1; 0, 1, 0, -1; 0, 0, 1, -1; 0, 0, 0, 1];
    mTemp = v2wm*transform;
    
    %===============================================
    %DIM
    
    dimTemp = str2num(coordSpace.('nidm_dimensionsInVoxels'))';
    
    %===============================================
    
    NxSPM.title = titleTemp;
    NxSPM.STAT = STATTemp;
    NxSPM.STATstr = STATStrTemp;
    NxSPM.nidm = nidmTemp;
    %Number of contrast vectors, currently only working with one.
    NxSPM.Ic = 1;
    NxSPM.DIM = dimTemp;
    NxSPM.M = mTemp;
    
end