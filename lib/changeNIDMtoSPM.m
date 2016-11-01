function NSPM = changeNIDMtoSPM(json)
    graph = json.('x_graph');
    filepathTemp = json.filepath;
    NSPM = struct;
    
    %============================================================
    %nidm - NOTE: In the standard format for the SPM file the design
    %matrix is derived from other fields and this field does not exist.
    
    nidmTemp = struct;
    designMatrix = searchforType('nidm_DesignMatrix', graph);
    
    locationID = searchforID(designMatrix{1}.('dc_description').('x_id'), graph);
    [~, filename, ext] = fileparts(locationID.('prov_atLocation').('x_value'));
    nidmTemp.DesMat = fullfile(json.filepath, [filename, ext]);
    
    [~, filename, ext] = fileparts(designMatrix{1}.('prov_atLocation').('x_value'));
    csvFilePath = fullfile(json.filepath, [filename, ext]);
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
    
    NSPM.nidm = nidmTemp;
    NSPM.xCon = xConTemp;
    NSPM.nidm.filepath = filepathTemp;
    
end
