%==========================================================================
%This function displays an NIDM_Results pack in a html format. It takes in
%one argument:
%
%jsonfilepath - the filepath to the NIDM-Results json file.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function webID = nidm_results_display(jsonfilepath)
    
    %Check input
    narginchk(1, 1);

    %Record users choice and filepath.
    jsondoc=spm_jsonread(jsonfilepath);
    [pathstr, str] = fileparts(jsonfilepath); 
    jsondoc.filepath = fullfile(pathstr, '..', str);
    jsondoc.filename = str;

    %Add path to required methods
    if exist('changeNIDMtoSPM') ~= 2
        addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'));
    end
    
    %Display the page and obtain the pages ID.
    webID = spm_results_export(changeNIDMtoSPM(jsondoc),changeNIDMtoxSPM(jsondoc),changeNIDMtoTabDat(jsondoc));
    
end