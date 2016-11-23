%To run the below tests use the following code:
%import matlab.unittest.TestSuite;
%tests = matlab.unittest.TestSuite.fromFile(which('nidmExampleDataTest'))
%result = run(tests)

classdef nidmExampleDataTest < matlab.unittest.TestCase
       
    methods
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
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_default');
            testCase.delete_html_file(data_path);
            nidm_results_display(fullfile(data_path, 'nidm.json'));
        end
        
        %Checking the experiment title is somewhere in the output HTML
        %file.
        function checkForTitle(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_default');
            testCase.delete_html_file(data_path);
            nidm_results_display(fullfile(data_path, 'nidm.json'));
            text = fileread(fullfile(data_path, 'index.html'));
            verifySubstring(testCase, text, 'tone counting vs baseline');
        end
        
        %Checking the original functionality of the viewer with the
        %original SPM, xSPM and TabDat functions is unaffected.
        function checkOriginalViewerRuns(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_output');
            testCase.delete_html_file(data_path);
            cwd = pwd;
            cd(data_path)
            testData = load(fullfile(data_path, 'nidm_example001.mat'));
            spm_results_export(testData.SPM, testData.xSPM, testData.TabDat);
            cd(cwd);
        end
        
        %Checking the viewer runs on FSL-nidm output.
        function checkViewerRunsFSL(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'fsl_default');
            testCase.delete_html_file(data_path);
            nidm_results_display(fullfile(data_path, 'nidm.json'));
        end
        
        %Checking the viewer runs on SPM-nidm output with no MIP.
        function checkViewerRunsSPMwoMIP(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_default');
            testCase.delete_html_file(data_path);
            nidm_results_display(fullfile(data_path, 'nidmwithoutMIP.json'));
        end
        
%         %Checking the nidm json is not damaged by the viewer.
%         function checkNIDMUnaffected(testCase)
%             fsl_default_dir = fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'fsl_default');
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