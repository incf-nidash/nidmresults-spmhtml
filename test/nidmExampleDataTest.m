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
            storeFile(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_default'), 'MaximumIntensityProjection.png');
            nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_default', 'nidm.json'));
            retrieveFile(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'ex_spm_default'), 'MaximumIntensityProjection.png');
        end
        
    end
end