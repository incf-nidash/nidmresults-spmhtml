%To run the below tests use the following code:
%import matlab.unittest.TestSuite;
%tests = matlab.unittest.TestSuite.fromFile(which('nidmExampleDataTest'))
%result = run(tests)

classdef nidmExampleDataTest < matlab.unittest.TestCase
    
    properties 
        TestData
    end
    
    methods(TestMethodSetup)
        %Rename the users HTML folder to prevent the tests damaging it.
        function storeUsersHTML(testCase)
            testCase.TestData.webID = '0';
            if exist(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'index.html'), 'file') == 2
                movefile(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'index.html'), fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'indexTemp.html'))
            end
        end
    end
    
    methods(TestMethodTeardown)
        %Remove the HTML folder created by test and move the users data back to the HTML folder.
        function removeTestHTML(testCase)
            if(~strcmp(testCase.TestData.webID, '0'))
                close(testCase.TestData.webID);
            end
            if exist(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'index.html'), 'file') == 2
                delete(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'index.html'))
            end
            if exist(fullfile(fileparts(mfilename('fullpath')), '..' , 'Data', 'indexTemp.html'), 'file') == 2
                movefile(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'indexTemp.html'), fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'index.html'), 'f')
            end
        end
    end 
        
    methods(Test)
        %Simply checking the viewer doesn't crash.
        function checkViewerRuns(testCase)
            testCase.TestData.webID = nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'nidm.json'), true);
        end
        %Checking the experiment title is somewhere in the output HTML
        %file.
        function checkForTitle(testCase)
            testCase.TestData.webID = nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'nidm.json'), true);
            text = fileread(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'index.html'));
            verifySubstring(testCase, text, 'tone counting vs baseline');
        end
        
        %Checking the original functionality of the viewer with the
        %original SPM, xSPM and TabDat functions is unaffected.
        function checkOriginalViewerRuns(testCase)
            testData = load(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'nidm_example001.mat'));
            testCase.TestData.webID = spm_results_export(testData.SPM, testData.xSPM, testData.TabDat);
        end
    end
end