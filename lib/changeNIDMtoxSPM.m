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
    %M
    
    [excursionSetMaps, excurIndices] = searchforType('nidm_ExcursionSetMap', graph);
    coordSpaceId = excursionSetMaps{1}.('nidm_inCoordinateSpace').('x_id');
    coordSpace = searchforID(coordSpaceId, graph);
    v2wm = spm_jsonread(coordSpace.nidm_voxelToWorldMapping);
    transform = [1, 0, 0, -1; 0, 1, 0, -1; 0, 0, 1, -1; 0, 0, 0, 1];
    mTemp = v2wm*transform;
    
    %===============================================
    %DIM
    
    dimTemp = str2num(coordSpace.('nidm_dimensionsInVoxels'))';
    
    %======================================================================
    %nidm - NOTE: In the standard format for SPM output the MIP is 
    %derived from other fields and this field does not exist.
    
    nidmTemp = struct;
    
    if isfield(excursionSetMaps{1}, 'nidm_hasMaximumIntensityProjection')
        mipFilepath = searchforID(excursionSetMaps{1}.nidm_hasMaximumIntensityProjection.('x_id'),graph);
        nidmTemp.MIP = getPathDetails(mipFilepath.('prov_atLocation').('x_value'), json.filepath);
    end 
    if ~isfield(excursionSetMaps{1}, 'nidm_hasMaximumIntensityProjection')
        %Find the units of the MIP.
        searchSpaceMaskMap = searchforType('nidm_SearchSpaceMaskMap', graph);
        searchSpace = searchforID(searchSpaceMaskMap{1}.('nidm_inCoordinateSpace').('x_id'), graph);
        voxelUnits = strrep(strrep(strrep(strrep(searchSpace.('nidm_voxelUnits'), '\"', ''), '[', ''), ']', ''), ',', '');
        
        %Generate the MIP.
        filenameNII = excursionSetMaps{1}.('nfo_fileName');
        generateMIP(json.filepath, filenameNII, dimTemp, voxelUnits);
        nidmTemp.MIP = spm_file(fullfile(json.filepath,'MIP.png'));
        
        %Store information about the new MIP in the NIDM pack. Temporarily
        %remove the filepath from the json object.
        filepathTemp = json.filepath;
        json = rmfield(json, 'filepath');
        
        %Create a structure to store information about the MIP.
        
        s = struct;
        s.x_id = ['niiri:', char(java.util.UUID.randomUUID)];
        s.x_type = {'dctype:Image'; 'prov:Entity'};
        s.dcterms_format = 'image/png';
        s.nfo_fileName = 'MIP.png';
        s.prov_atLocation.x_type = 'xsd:anyURI';
        s.prov_atLocation.x_value = 'MIP.png';
        
        %Update the graph.
        graph{excurIndices{1}}.nidm_hasMaximumIntensityProjection.x_id = s.x_id;
        graph{length(graph)+1} = s;
        json.x_graph = graph;
        
        json_file = fullfile(filepathTemp, 'nidm.json');
        spm_jsonwrite(json_file, json);
        
        % Replace 'x_' back with '@' in the json document (Matlab cannot
        % handle variable names starting with '@' so those are replaced when 
        % reading with spm_jsonread)
        json_str = fileread(json_file);
        json_str = strrep(json_str, 'x_', '@');
        fid = fopen(json_file, 'w');
        fwrite(fid, json_str, '*char');
        fclose(fid);
        
        json.filepath = filepathTemp;
        
    end
    
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