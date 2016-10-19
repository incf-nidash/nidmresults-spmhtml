%To run the below tests use the following code:
%import matlab.unittest.TestSuite;
%tests = matlab.unittest.TestSuite.fromFile(which('nidmExampleDataTest'))
%result = run(tests)

classdef nidmExampleDataTest < matlab.unittest.TestCase
    
    methods(TestMethodSetup)
        %Rename the users HTML folder to prevent the tests damaging it.
        function storeUsersHTML(testCase)
            if exist(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'html'), 'dir') == 7 
                movefile(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'html'), fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'htmlTemp'))
            end
        end
    end
    
    methods(TestMethodTeardown)
        %Remove the HTML folder created by test and move the users data back to the HTML folder.
        function removeTestHTML(testCase)
            com.mathworks.mlservices.MatlabDesktopServices.getDesktop.closeGroup('Web Browser');
            if exist(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'html'), 'dir') == 7
                rmdir(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'html'), 's')
            end
            if exist(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'htmlTemp'), 'dir') == 7
                movefile(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'htmlTemp'), fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'html'), 'f')
            end
        end
    end 
        
    methods(Test)
        %Simply checking the viewer doesn't crash.
        function checkViewerRuns(testCase)
            nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'nidm.json'), true);
        end
        %Checking the experiment title is somewhere in the output HTML
        %file.
        function checkForTitle(testCase)
            nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'nidm.json'), true);
            text = fileread(fullfile(fileparts(mfilename('fullpath')), '..', 'Data', 'html', 'index_001.html'));
            verifySubstring(testCase, text, 'tone counting vs baseline');
        end
    end
end