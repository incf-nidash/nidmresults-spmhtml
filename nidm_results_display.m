function nidm_results_display(jsonfilepath)
    jsondoc=spm_jsonread(jsonfilepath);
    pathstr = fileparts(jsonfilepath); 
    jsondoc.filepath = pathstr;
    if exist('changeNIDMtoSPM') ~= 2
        addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'));
    end
    spm_results_export(changeNIDMtoSPM(jsondoc),changeNIDMtoxSPM(jsondoc),changeNIDMtoTabDat(jsondoc));
end