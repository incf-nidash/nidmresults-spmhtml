%==========================================================================
%Unit tests for testing features of the viewer. To run the below run the 
%runTest function.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

classdef testFeatures < matlab.unittest.TestCase
       
    methods
        %Function for deleting any HTML generated previously by the viewer.
        function delete_html_file(testCase, data_path)
            index = fullfile(data_path, 'index.html');
            if exist(index, 'file')
                delete(index);
            end
        end
    end
        
    methods(Test)
        
        %Checking the viewer runs on SPM-nidm input.
        function checkViewerRunsSPM(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'ex_spm_default.nidm');
            if(~exist(data_path, 'dir'))
                mkdir(data_path)
                websave(fullfile(data_path, 'tmp.zip'), 'http://neurovault.org/collections/2210/ex_spm_default.nidm.zip');
                unzip(fullfile(data_path, 'tmp.zip'), fullfile(data_path, '.'));
            end
            testCase.delete_html_file(data_path);
            nidm_results_display(data_path);
        end
        
        %Checking the experiment title is somewhere in the output HTML
        %file.
        function checkForTitle(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'ex_spm_default.nidm');
            testCase.delete_html_file(data_path);
            nidm_results_display(data_path);
            text = fileread(fullfile(data_path, 'index.html'));
            verifySubstring(testCase, text, 'tone counting vs baseline');
        end
        
        %Checking the original functionality of the viewer with the
        %original SPM, xSPM and TabDat functions is unaffected.
        function checkOriginalViewerRuns(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'ex_spm_output');
            testCase.delete_html_file(data_path);
            cwd = pwd;
            cd(data_path)
            testData = load(fullfile(data_path, 'nidm_example001.mat'));
            spm_results_export(testData.SPM, testData.xSPM, testData.TabDat);
            cd(cwd);
        end
        
        %Checking the viewer runs on FSL-nidm output.
        function checkViewerRunsFSL(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'fsl_default_130.nidm');
            testCase.delete_html_file(data_path);
            nidm_results_display(data_path);
        end
        
        %Checking the viewer runs on SPM-nidm output with no MIP.
        function checkViewerRunsSPMwoMIP(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'ex_spm_default_wo_MIP');
            %Copy contents of ex_spm_default NIDM pack.
            copyfile(fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'ex_spm_default.nidm', '*'),...
                fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'ex_spm_default_wo_MIP'));
            %Delete the pre-existing jsonld.
            delete(fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'ex_spm_default_wo_MIP', 'nidm.jsonld'));
            %Copy the jsonld without the MIP into the NIDM pack.
            copyfile(fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'testJsons', 'nidm.jsonld'), fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'ex_spm_default_wo_MIP'));
            %Run the test.
            testCase.delete_html_file(data_path);
            nidm_results_display(data_path);
        end
        
%         %Checking the nidm json is not damaged by the viewer.
%         function checkNIDMUnaffected(testCase)
%             fsl_default_dir = fullfile(fileparts(mfilename('fullpath')), '..', 'data', 'fsl_default');
%             testCase.delete_html_file(fsl_default_dir);
%             nidm_results_display(fullfile(fsl_default_dir, 'nidm.json'));
%             originalNIDM = spm_jsonread(fullfile(fsl_default_dir, 'nidmWithoutMip.json'));
%             currentNIDM = spm_jsonread(fullfile(fsl_default_dir, 'nidm.json'));
%             %Choose a random vertex in the graph that we know should not have been changed.
%             testObject = 20;
%             while testObject == 20
%                 testObject = randi(length(originalNIDM.x_graph));
%             end
%             verifyEqual(testCase, currentNIDM.x_graph{testObject}, originalNIDM.x_graph{testObject});
%         end

    end
end