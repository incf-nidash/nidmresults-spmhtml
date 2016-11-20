%==========================================================================
%Generate an object with the same format as the SPM-output variable, xSPM, 
%using the information from an input NIDM-Results json pack. This takes in 
%one argument:
%
%json - the spm_jsonread form of the NIDM-Results json file.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function NxSPM = changeNIDMtoxSPM(json)
    
    graph = json.('x_graph');
    NxSPM = struct;
    
    %======================================================================
    %title
    
    %Find the contrast map holding the title.
    contrastMaps = searchforType('nidm_ContrastMap', graph);
    for i = 1:length(contrastMaps)
        if isfield(contrastMaps{i}, 'nidm_contrastName')
            titleTemp = contrastMaps{i}.('nidm_contrastName');
        end
    end 
    
    %======================================================================
    %STAT
    
    %Using getStatType, obtain the statisticMaps objects and statistic type. 
    [STATTemp, statisticMaps] = getStatType(graph);
       
    %======================================================================
    %STATStr
    
    %Obtain the degrees of freedom.
    for i = 1:length(statisticMaps)
        if isfield(statisticMaps{i}, 'nidm_errorDegreesOfFreedom')
            effectDegrees = statisticMaps{i}.('nidm_effectDegreesOfFreedom').('x_value');
            errorDegrees = statisticMaps{i}.('nidm_errorDegreesOfFreedom').('x_value');
        end
    end 
    
    %Add the degrees of freedom as a subscript.
    effectDegrees = num2str(round(str2num(effectDegrees)));
    errorDegrees = num2str(round(str2num(errorDegrees)));
    
    if strcmp(STATTemp, 'T') || strcmp(STATTemp, 'X')
        STATStrTemp = [STATTemp '_{' errorDegrees '}'];
    elseif strcmp(STATTemp, 'Z') || strcmp(STATTemp, 'P')
        STATStrTemp = STATTemp;
    else
        STATStrTemp = [STATTemp '_{' effectDegrees ',' errorDegrees '}'];
    end
    
    %===============================================
    %M
    
    %Locate the excursion set maps and their indices in the graph.
    [excursionSetMaps, excurIndices] = searchforType('nidm_ExcursionSetMap', graph);
    coordSpaceId = excursionSetMaps{1}.('nidm_inCoordinateSpace').('x_id');
    coordSpace = searchforID(coordSpaceId, graph);
    
    %Obtain the voxel to world mapping and transform it to obtain M.
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
    
    %If there's already an MIP, save it's location, else generate one.
    if isfield(excursionSetMaps{1}, 'nidm_hasMaximumIntensityProjection')
        mipFilepath = searchforID(excursionSetMaps{1}.nidm_hasMaximumIntensityProjection.('x_id'),graph);
        nidmTemp.MIP = getPathDetails(mipFilepath.('prov_atLocation').('x_value'), json.filepath);
    else
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
        filenameTemp = json.filename;
        json = rmfield(json, 'filepath');
        json = rmfield(json, 'filename');
        
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
        
        spm_jsonwrite(fullfile(filepathTemp, '..', 'jsons', [filenameTemp '.json']), json);
        json.filepath = filepathTemp;
        json.filename = filenameTemp;
        
    end
    
    %======================================================================
    
    NxSPM.title = titleTemp;
    NxSPM.STAT = STATTemp;
    NxSPM.STATstr = STATStrTemp;
    NxSPM.nidm = nidmTemp;
    %Number of contrast vectors, currently only working with one.
    NxSPM.Ic = 1;
    NxSPM.DIM = dimTemp;
    NxSPM.M = mTemp;
    
end