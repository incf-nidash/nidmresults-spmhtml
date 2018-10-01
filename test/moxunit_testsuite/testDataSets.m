%==========================================================================
%Unit tests for testing whether datasets run in the viewer. To run the
%below run the runTest function. The html files generated can be found in
%the corresponding folders after the test has been run.
%
%Authors: Thomas Maullin, Camille Maumet. (Adapted from the testDataSets
%matlab unittest function).
%==========================================================================

function test_suite=testDataSets
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

%Function for deleting any HTML generated previously by the viewer
function delete_html_file(data_path)
    index = fullfile(data_path,'index.html');
    if exist(index, 'file')
       delete(index);
    else
        for(i = 1:8)
            index = fullfile(data_path,['index', num2str(i), '.html']);
            if exist(index, 'file')
                delete(index);
            end
        end
    end
end

%Test viewer displays ex_spm_HRF_informed_basis.nidm
function test_ex_spm_HRF_informed_basis()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_HRF_informed_basis.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_HRF_informed_basis.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_conjunction.nidm
function test_ex_spm_conjunction()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_conjunction.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_conjunction.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_contrast_mask.nidm
function test_ex_spm_contrast_mask()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_contrast_mask.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_contrast_mask.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_default.nidm
function test_ex_spm_default()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_default.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_default.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_full_example001.nidm
function test_ex_spm_full_example001()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_full_example001.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_full_example001.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_group_ols.nidm
function test_ex_spm_group_ols()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_group_ols.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_group_ols.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_group_wls.nidm
function test_ex_spm_group_wls()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_group_wls.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_group_wls.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_partial_conjunction.nidm
function test_ex_spm_partial_conjunction()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_partial_conjunction.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_partial_conjunction.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_temporal_derivative.nidm
function test_ex_spm_temporal_derivative()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_temporal_derivative.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_temporal_derivative.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_thr_clustfwep05.nidm
function test_ex_spm_thr_clustfwep05()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_thr_clustfwep05.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_thr_clustfwep05.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_thr_clustunck10.nidm
function test_ex_spm_thr_clustunck10()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_thr_clustunck10.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_thr_clustunck10.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_thr_voxelfdrp05.nidm
function test_ex_spm_thr_voxelfdrp05()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_thr_voxelfdrp05.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_thr_voxelfdrp05.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_thr_voxelfwep05.nidm
function test_ex_spm_thr_voxelfwep05()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_thr_voxelfwep05.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_thr_voxelfwep05.nidm.zip'), 'All');
end

%Test viewer displays ex_spm_thr_voxelunct4.nidm
function test_ex_spm_thr_voxelunct4()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','ex_spm_thr_voxelunct4.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','ex_spm_thr_voxelunct4.nidm.zip'), 'All');
end

%Test viewer displays fsl_con_f.nidm
function test_fsl_con_f()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_con_f.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_con_f.nidm.zip'), 'All');
end

%Test viewer displays fsl_con_f.nidm
function test_fsl_con_f_multiple()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_con_f_multiple.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_con_f_multiple.nidm.zip'), 'All');
end

%Test viewer displays fsl_contrast_mask.nidm
function test_fsl_contrast_mask()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_contrast_mask.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_contrast_mask.nidm.zip'), 'All');
end

%Test viewer displays fsl_default.nidm
function test_fsl_default()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_default.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_default.nidm.zip'), 'All');
end

%Test viewer displays fsl_full_examples001.nidm
function test_fsl_full_examples001()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_full_examples001.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_full_examples001.nidm.zip'), 'All');
end

%Test viewer displays fsl_gamma_basis.nidm
function test_fsl_gamma_basis()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_gamma_basis.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_gamma_basis.nidm.zip'), 'All');
end

%Test viewer displays fsl_gaussian.nidm
function test_fsl_gaussian()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_gaussian.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_gaussian.nidm.zip'), 'All');
end

%Test viewer displays fsl_group_btw.nidm
function test_fsl_group_btw()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_group_btw.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_group_btw.nidm.zip'), 'All');
end

%Test viewer displays fsl_group_ols.nidm
function test_fsl_group_ols()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_group_ols.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_group_ols.nidm.zip'), 'All');
end

%Test viewer displays fsl_group_wls.nidm
function test_fsl_group_wls()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_group_wls.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_group_wls.nidm.zip'), 'All');
end

%Test viewer displays fsl_hrf_fir.nidm
function test_fsl_hrf_fir()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_hrf_fir.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_hrf_fir.nidm.zip'), 'All');
end

%Test viewer displays fsl_hrf_gammadiff.nidm
function test_fsl_hrf_gammadiff()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_hrf_gammadiff.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_hrf_gammadiff.nidm.zip'), 'All');
end

%Test viewer displays fsl_thr_clustfwep05.nidm
function test_fsl_thr_clustfwep05()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_thr_clustfwep05.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_thr_clustfwep05.nidm.zip'), 'All');
end

%Test viewer displays fsl_thr_voxelfwep05.nidm
function test_fsl_thr_voxelfwep05()
    data_path = fullfile(fileparts(mfilename('fullpath')),'..','data','fsl_thr_voxelfwep05.nidm.zip');
    delete_html_file(strrep(data_path, '.zip', ''));
    nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'data','fsl_thr_voxelfwep05.nidm.zip'), 'All');
end
