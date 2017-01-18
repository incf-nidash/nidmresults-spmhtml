%==========================================================================
%Unit tests for testing whether datasets run in the viewer. To run the
%below run the runTest function. The html files generated can be found in
%the corresponding folders after the test has been run.
%
%Authors: Thomas Maullin, Camille Maumet. (Generated by the createTest
%function).
%==========================================================================
 classdef testDataSets < matlab.unittest.TestCase
 
 	 methods
 	 	 %Function for deleting any HTML generated previously by the viewer
 	 	 function delete_html_file(testCase, data_path)
 	 	 	 index = fullfile(data_path,'index.html');
 	 	 	 if exist(index, 'file')
 	 	 	 	 delete(index);
 	 	 	 end
 	 	 end
 	 end
 
 	 methods(Test)
 
 	 	 %Test viewer displays ex_spm_HRF_informed_basis
 	 	 function test_ex_spm_HRF_informed_basis(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_HRF_informed_basis');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_HRF_informed_basis.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_HRF_informed_basis.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_conjunction
 	 	 function test_ex_spm_conjunction(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_conjunction');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_conjunction.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_conjunction.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_contrast_mask
 	 	 function test_ex_spm_contrast_mask(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_contrast_mask');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_contrast_mask.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_contrast_mask.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_default
 	 	 function test_ex_spm_default(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_default');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/1692/ex_spm_default.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_default.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_full_example001
 	 	 function test_ex_spm_full_example001(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_full_example001');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_full_example001.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_full_example001.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_group_ols
 	 	 function test_ex_spm_group_ols(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_group_ols');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_group_ols.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_group_ols.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_group_wls
 	 	 function test_ex_spm_group_wls(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_group_wls');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_group_wls.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_group_wls.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_partial_conjunction
 	 	 function test_ex_spm_partial_conjunction(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_partial_conjunction');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_partial_conjunction.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_partial_conjunction.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_temporal_derivative
 	 	 function test_ex_spm_temporal_derivative(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_temporal_derivative');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_temporal_derivative.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_temporal_derivative.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_thr_clustfwep05
 	 	 function test_ex_spm_thr_clustfwep05(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_thr_clustfwep05');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_thr_clustfwep05.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_thr_clustfwep05.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_thr_clustunck10
 	 	 function test_ex_spm_thr_clustunck10(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_thr_clustunck10');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_thr_clustunck10.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_thr_clustunck10.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_thr_voxelfdrp05
 	 	 function test_ex_spm_thr_voxelfdrp05(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_thr_voxelfdrp05');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_thr_voxelfdrp05.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_thr_voxelfdrp05.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_thr_voxelfwep05
 	 	 function test_ex_spm_thr_voxelfwep05(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_thr_voxelfwep05');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_thr_voxelfwep05.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_thr_voxelfwep05.json'));
 	 	 end
 
 	 	 %Test viewer displays ex_spm_thr_voxelunct4
 	 	 function test_ex_spm_thr_voxelunct4(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','ex_spm_thr_voxelunct4');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/ex_spm_thr_voxelunct4.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','ex_spm_thr_voxelunct4.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_con_f
 	 	 function test_fsl_con_f(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_con_f');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/fsl_con_f.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_con_f.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_con_f_130
 	 	 function test_fsl_con_f_130(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_con_f_130');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/IBRBTZPC/fsl_con_f_130.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_con_f_130.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_contrast_mask
 	 	 function test_fsl_contrast_mask(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_contrast_mask');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/fsl_contrast_mask.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_contrast_mask.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_default
 	 	 function test_fsl_default(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_default');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/fsl_default.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_default.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_default_1
 	 	 function test_fsl_default_1(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_default_1');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/ONZVVHXL/fsl_default_1.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_default_1.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_full_examples001
 	 	 function test_fsl_full_examples001(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_full_examples001');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/fsl_full_examples001.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_full_examples001.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_gamma_basis
 	 	 function test_fsl_gamma_basis(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_gamma_basis');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/fsl_gamma_basis.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_gamma_basis.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_gaussian
 	 	 function test_fsl_gaussian(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_gaussian');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/fsl_gaussian.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_gaussian.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_group_ols
 	 	 function test_fsl_group_ols(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_group_ols');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/fsl_group_ols.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_group_ols.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_group_wls
 	 	 function test_fsl_group_wls(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_group_wls');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/fsl_group_wls.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_group_wls.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_hrf_fir
 	 	 function test_fsl_hrf_fir(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_hrf_fir');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/fsl_hrf_fir.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_hrf_fir.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_hrf_gammadiff
 	 	 function test_fsl_hrf_gammadiff(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_hrf_gammadiff');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/fsl_hrf_gammadiff.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_hrf_gammadiff.json'));
 	 	 end
 
 	 	 %Test viewer displays fsl_thr_clustfwep05
 	 	 function test_fsl_thr_clustfwep05(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','fsl_thr_clustfwep05');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/BNRPBNVV/fsl_thr_clustfwep05.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','fsl_thr_clustfwep05.json'));
 	 	 end
 
 	 	 %Test viewer displays pain_01
 	 	 function test_pain_01(testCase)
 	 	 	 data_path = fullfile(fileparts(mfilename('fullpath')),'..','Data','pain_01');
 	 	 	 if(~exist(data_path, 'dir'))
 	 	 	 	 mkdir(data_path);
 	 	 	 	 websave([data_path, filesep, 'temp.zip'], 'http://neurovault.org/collections/NJXQPEEK/pain_01.nidm.zip');
 	 	 	 	 unzip([data_path, filesep, 'temp.zip'], [data_path, filesep]);
 	 	 	 end
 	 	 	 testCase.delete_html_file(data_path);
 	 	 	 nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'jsons','pain_01.json'));
 	 	 end
 
 	 end
 
 end