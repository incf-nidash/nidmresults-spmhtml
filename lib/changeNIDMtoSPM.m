function NSPM = changeNIDMtoSPM(json)
    graph = json.('@graph');
    NSPM = struct;
    
    %============================================================
    %nidm - NOTE: In the standard format for the SPM file the design
    %matrix is derived from other fields and this field does not exist.
    
    nidmTemp = struct;
    designMatrix = searchforType('nidm_DesignMatrix', graph);
    
    locationID = searchforID(designMatrix{1}.('dc:description').('@id'), graph);
    nidmTemp.DesMat = fullfile(json.filepath, locationID.('prov:atLocation').('@value'));
    
    csvFilePath = fullfile(json.filepath, designMatrix{1}.('prov:atLocation').('@value'));
    csvFile = csvread(csvFilePath);
    nidmTemp.dim = size(csvFile);
    
    %=============================================================
    %xCon
    
    xConTemp = struct;
    contrastWeightMatrix = searchforType('obo_contrastweightmatrix', graph);
    xConTemp(1).c = str2num(contrastWeightMatrix{1}.('prov:value'))';
    
    %=============================================================
    
    NSPM.nidm = nidmTemp;
    NSPM.xCon = xConTemp;
    
end
