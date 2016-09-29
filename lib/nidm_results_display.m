function nidm_results_display(json)
    spm_results_export(changeNIDMtoSPM(json),changeNIDMtoxSPM(json),changeNIDMtoTabDat(json))
end