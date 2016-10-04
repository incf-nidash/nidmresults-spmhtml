function nidm_results_display(jsonfilepath)
    json=spm_jsonread(jsonfilepath);
    [pathstr,name,ext] = fileparts(jsonfilepath); 
    json.filepath = pathstr;
    if exist('changeNIDMtoSPM') ~= 2
        addpath(fileparts(mfilename('fullpath')), 'lib')
        disp(fileparts(mfilename('fullpath')), 'lib')
    end
    spm_results_export(changeNIDMtoSPM(json),changeNIDMtoxSPM(json),changeNIDMtoTabDat(json));
end