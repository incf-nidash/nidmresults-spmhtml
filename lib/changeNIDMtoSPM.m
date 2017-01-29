%==========================================================================
%Generate an object with the same format as the SPM-output variable, SPM, 
%using the information from an input NIDM-Results json pack. This takes in 
%two or three argument:
%
%graph - the nidm-results graph
%filepathTemp - the filepath to the NIDM pack.
%exObj - an object containing all information about multiple excursions 
%sets.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function NSPM = changeNIDMtoSPM(graph, filepathTemp, exObj)
    
    % Checking inputs.
    if nargin == 2
        multipleExcursions = false;
    end
    if nargin == 3
        multipleExcursions = true;
        exNum = exObj{1};
        exLabels = exObj{2};
    end
    
    NSPM = struct;
    
    %======================================================================
    %nidm - NOTE: In the standard format for the SPM file the design
    %matrix is derived from other fields and this field does not exist.
    
    nidmTemp = struct;
    designMatrix = searchforType('nidm_DesignMatrix', graph);
    if(multipleExcursions)
        designMatrix = relevantToExcursion(designMatrix, exNum, exLabels);
    end
    
    % Find the location of the design matrix (case depends on the version of 
    % the exporter, in the future we should look at the URI to avoid relying on 
    % attribute names)
    if isfield(designMatrix{1}, 'dc_description')
        locationID = searchforID(designMatrix{1}.('dc_description').('x_id'), graph);
    elseif isfield(designMatrix{1}, 'dc_Description')
        locationID = searchforID(designMatrix{1}.('dc_Description').('x_id'), graph);
    end
    nidmTemp.DesMat = getPathDetails(locationID.('prov_atLocation').('x_value'), filepathTemp);
    
    %Read the csv file and obtain it's dimensions.
    csvFilePath = getPathDetails(designMatrix{1}.('prov_atLocation').('x_value'), filepathTemp);
    csvFile = csvread(csvFilePath);
    nidmTemp.dim = size(csvFile);
    
    %======================================================================
    %xCon
    
    xConTemp = struct;
    
    %Search for contrastwieght matrix objects to obtain a contrast vector.
    contrastWeightMatrix = searchforType('obo_contrastweightmatrix', graph);
    if(isempty(contrastWeightMatrix))
        contrastWeightMatrix = searchforType('obo:STATO_0000323', graph);
    end   
    if(multipleExcursions)
        contrastWeightMatrix = relevantToExcursion(contrastWeightMatrix, exNum, exLabels);
    end
    
    xConTemp(1).c = str2num(contrastWeightMatrix{1}.('prov_value'))';
    
    %======================================================================
    %xX
    
    xXtemp = struct;
    
    %Find the design matrix csv.
    designMatrixFilename = designMatrix{1}.prov_atLocation.x_value;
    [~, name, ext] = fileparts(designMatrixFilename);
    xXtemp.xKXs.X = csvread(fullfile(filepathTemp, [name, ext]));
    
    %Get the regressor names in required format.
    remain = strrep(strrep(strrep(strrep(designMatrix{1}.nidm_regressorNames, '\"', ''), '[', ''), ']', ''), ',', '');
    counter = 1;
    % Deal with the case of empty regressor names
    if isempty(remain)
        regNameCell{1} = '';
    else
        while ~isempty(remain)
            [token, remain] = strtok(remain, ' ');
            regNameCell{counter} = token;
            counter = counter+1;
        end
    end
    
    xXtemp.name = regNameCell;
    
    %Create the nKX design matrix.
    xXtemp.nKX = spm_DesMtx('sca',xXtemp.xKXs.X,xXtemp.name);
    
    %======================================================================
    %Assign fields of NSPM.
    
    NSPM.nidm = nidmTemp;
    NSPM.xCon = xConTemp;
    NSPM.xX = xXtemp;
    NSPM.nidm.filepath = filepathTemp;
    
end
