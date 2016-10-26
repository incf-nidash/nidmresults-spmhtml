function webID = nidm_results_display(jsonfilepath)
    
    %Checks on input
    narginchk(1, 1);
%     if nargin == 2
%         validateattributes(overWrite,{'logical'}, {'scalar'});
%     end

    %Record users choice and filepath.
    jsondoc=spm_jsonread(jsonfilepath);
    pathstr = fileparts(jsonfilepath); 
    jsondoc.filepath = pathstr;

    %Add path to required methods
    if exist('changeNIDMtoSPM') ~= 2
        addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'));
    end

    webID = spm_results_export(changeNIDMtoSPM(jsondoc),changeNIDMtoxSPM(jsondoc),changeNIDMtoTabDat(jsondoc));
    
end