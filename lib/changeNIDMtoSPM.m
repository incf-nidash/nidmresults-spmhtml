%==========================================================================
%Generate an object with a similar format to the SPM-output variable, SPM, 
%using the information from an input NIDM-Results json pack. This takes in 
%one argument:
%
%json - the spm_jsonread form of the NIDM-Results json file.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function NSPM = changeNIDMtoSPM(json)
    graph = json.('x_graph');
    filepathTemp = json.filepath;
    
    %Create NSPM hashmap.
    ExcursionSets = searchforType('nidm_ExcursionSetMap', graph);
    ExSetName = cellfun(@(x) x.nfo_fileName, ExcursionSets, 'UniformOutput', false)
    SPMStruct = arrayfun(@(x) struct(), 1:length(ExcursionSets), 'UniformOutput', false)
    NSPM = containers.Map(ExSetName, SPMStruct, 'UniformValues', false);
    
    %============================================================
    %nidm - NOTE: In the standard format for the SPM file the design
    %matrix is derived from other fields and this field does not exist.
    
    nidmTemp = struct;
    designMatrix = searchforType('nidm_DesignMatrix', graph);
    
    locationID = searchforID(designMatrix{1}.('dc_description').('x_id'), graph);
    nidmTemp.DesMat = getPathDetails(locationID.('prov_atLocation').('x_value'), json.filepath);
    
    csvFilePath = getPathDetails(designMatrix{1}.('prov_atLocation').('x_value'), json.filepath);
    csvFile = csvread(csvFilePath);
    nidmTemp.dim = size(csvFile);
    
    %=============================================================
    %xCon
    
    xConTemp = struct;
    contrastWeightMatrix = searchforType('obo_contrastweightmatrix', graph);
    if(isempty(contrastWeightMatrix))
        contrastWeightMatrix = searchforType('obo:STATO_0000323', graph);
    end    
    xConTemp(1).c = str2num(contrastWeightMatrix{1}.('prov_value'))';
    
    %=============================================================
    %xX
    
    xXtemp = struct;
    
    designMatrices = searchforType('nidm_DesignMatrix', graph);
    designMatrixFilename = designMatrices{1}.prov_atLocation.x_value;
    [~, name, ext] = fileparts(designMatrixFilename);
    xXtemp.xKXs.X = csvread(fullfile(filepathTemp, [name, ext]));
    
    %Get the regressor names in required format.
    remain = strrep(strrep(strrep(strrep(designMatrices{1}.nidm_regressorNames, '\"', ''), '[', ''), ']', ''), ',', '');
    counter = 1;
    while ~isempty(remain)
        [token, remain] = strtok(remain, ' ');
        regNameCell{counter} = token;
        counter = counter+1;
    end
    
    xXtemp.name = regNameCell;
    
    xXtemp.nKX = spm_DesMtx('sca',xXtemp.xKXs.X,xXtemp.name);
    
    %=============================================================
    
    NSPM.nidm = nidmTemp;
    NSPM.xCon = xConTemp;
    NSPM.xX = xXtemp;
    NSPM.nidm.filepath = filepathTemp;
    
end
