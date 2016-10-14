%To run the below tests use the following code:
%import matlab.unittest.TestSuite;
%tests = matlab.unittest.TestSuite.fromFile(which('nidmExampleDataTest'))
%result = run(tests)

classdef nidmExampleDataTest < matlab.unittest.TestCase
    
    methods(TestMethodSetup)
        %Rename the users HTML folder to prevent the tests damaging it.
        function storeUsersHTML(testCase)
            if exist(strrep(fileparts(mfilename('fullpath')), 'test', 'Data\html')) == 7 
                movefile(strrep(fileparts(mfilename('fullpath')), 'test', 'Data\html'), strrep(fileparts(mfilename('fullpath')), 'test', 'Data\htmlTemp'))
            end
        end
    end
    
    methods(TestMethodTeardown)
        %Remove the HTML folder created by test.
        function removeTestHTML(testCase)
            pause(0.1);
            if exist(strrep(fileparts(mfilename('fullpath')), 'test', 'Data\html')) == 7
                rmdir(strrep(fileparts(mfilename('fullpath')), 'test', 'Data\html'), 's')
            end
        end
        %Move the users data back to the HTML folder.
        function addUsersHTML(testCase)
            if exist(strrep(fileparts(mfilename('fullpath')), 'test', 'Data\htmlTemp')) == 7
                movefile(strrep(fileparts(mfilename('fullpath')), 'test', 'Data\htmlTemp'), strrep(fileparts(mfilename('fullpath')), 'test', 'Data\html'))
            end 
        end
    end 
        
    methods(Test)
        %Simply checking the viewer doesn't crash.
        function checkViewerRuns(testCase)
            nidm_results_display(strrep(fileparts(mfilename('fullpath')), 'test', 'Data\nidm.json'), 1);
        end
        %Checking the experiment title is somewhere in the output HTML
        %file.
        function checkForTitle(testCase)
            nidm_results_display(strrep(fileparts(mfilename('fullpath')), 'test', 'Data\nidm.json'), 1);
            text = fileread(strrep(fileparts(mfilename('fullpath')), 'test', 'Data\html\index_001.html'));
            verifySubstring(testCase, text, 'tone counting vs baseline');
        end
    end
end