%To run the below tests use the following code:
%import matlab.unittest.TestSuite;
%tests = matlab.unittest.TestSuite.fromFile(which('nidmExampleDataTest'))
%result = run(tests)

classdef nidmExampleDataTest < matlab.unittest.TestCase
    
    methods(TestMethodSetup)
        
        %Rename the users HTML folder to prevent the tests damaging it.
        function storeUsersHTML(testCase)
            storeFile(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'fsl_default'));
            storeFile(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_default'));
            storeFile(pwd); 
        end
        
    end
        
    methods(Test)
        
        %Checking the viewer runs on SPM-nidm input.
        function checkViewerRunsSPM(testCase)
            nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_default', 'nidm.json'));
        end
        
        %Checking the experiment title is somewhere in the output HTML
        %file.
        function checkForTitle(testCase)
            nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_default', 'nidm.json'));
            text = fileread(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_default', 'index.html'));
            verifySubstring(testCase, text, 'tone counting vs baseline');
        end
        
        %Checking the original functionality of the viewer with the
        %original SPM, xSPM and TabDat functions is unaffected.
        function checkOriginalViewerRuns(testCase)
            testData = load(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_output', 'nidm_example001.mat'));
            spm_results_export(testData.SPM, testData.xSPM, testData.TabDat);
        end
        
        %Checking the viewer runs on FSL-nidm output.
        function checkViewerRunsFSL(testCase)
            nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'fsl_default', 'nidm.json'));
        end
        
        %Checking the viewer runs on SPM-nidm output with no MIP.
        function checkViewerRunsSPMwoMIP(testCase)
            nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_default', 'nidmwithoutMIP.json'));
        end
        
        %Checking the nidm json is not damaged by the viewer.
        function checkNIDMUnaffected(testCase)
            nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'fsl_default', 'nidm.json'));
            originalNIDM = spm_jsonread('C:\Users\owner\Documents\Project-NIDASH\nidmresults-spmhtml\Data\fsl_default\nidmWithoutMip.json');
            currentNIDM = spm_jsonread('C:\Users\owner\Documents\Project-NIDASH\nidmresults-spmhtml\Data\fsl_default\nidm.json');
            %Choose a random vertex in the graph that we know should not have been changed.
            testObject = 20;
            while testObject == 20
                testObject = randi(length(originalNIDM.x_graph));
            end
            verifyEqual(testCase, currentNIDM.x_graph{testObject}, originalNIDM.x_graph{testObject});
        end
    end
end