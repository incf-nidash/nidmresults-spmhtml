function nidm_results_display(jsonfilepath)
    json=spm_jsonread(jsonfilepath);
    [pathstr,name,ext] = fileparts(jsonfilepath); 
    json.filepath = pathstr;
    spm_results_export(changeNIDMtoSPM(json),changeNIDMtoxSPM(json),changeNIDMtoTabDat(json));
end