%To run the below tests use the following code:
%import matlab.unittest.TestSuite;
%tests = matlab.unittest.TestSuite.fromFile(which('nidmExampleDataTest'))
%result = run(tests)

classdef nidmExampleDataTest < matlab.unittest.TestCase
    
    methods(TestMethodSetup)
        %Rename the users HTML folder to prevent the tests damaging it.
        function storeUsersHTML(testCase)
            if exist(strrep(fileparts(mfilename('fullpath')), 'test', strcat('Data', filesep, 'html'))) == 7 
                movefile(strrep(fileparts(mfilename('fullpath')), 'test', strcat('Data', filesep, 'html')), strrep(fileparts(mfilename('fullpath')), 'test', strcat('Data', filesep, 'htmlTemp')))
            end
        end
    end
    
    methods(TestMethodTeardown)
        %Remove the HTML folder created by test and move the users data back to the HTML folder.
        function removeTestHTML(testCase)
            if exist(strrep(fileparts(mfilename('fullpath')), 'test', strcat('Data', filesep, 'html'))) == 7
                rmdir(strrep(fileparts(mfilename('fullpath')), 'test', strcat('Data', filesep, 'html')), 's')
            end
            if exist(strrep(fileparts(mfilename('fullpath')), 'test', strcat('Data', filesep, 'htmlTemp'))) == 7
                movefile(strrep(fileparts(mfilename('fullpath')), 'test', strcat('Data', filesep, 'htmlTemp')), strrep(fileparts(mfilename('fullpath')), 'test', strcat('Data', filesep, 'html')), 'f')
            end
            com.mathworks.mlservices.MatlabDesktopServices.getDesktop.closeGroup('Web Browser');
        end
    end 
        
    methods(Test)
        %Simply checking the viewer doesn't crash.
        function checkViewerRuns(testCase)
            nidm_results_display(strrep(fileparts(mfilename('fullpath')), 'test', strcat('Data', filesep, 'nidm.json')), true);
        end
        %Checking the experiment title is somewhere in the output HTML
        %file.
        function checkForTitle(testCase)
            nidm_results_display(strrep(fileparts(mfilename('fullpath')), 'test', strcat('Data', filesep, 'nidm.json')), true);
            text = fileread(strrep(fileparts(mfilename('fullpath')), 'test', strcat('Data', filesep, 'html', filesep, 'index_001.html')));
            verifySubstring(testCase, text, 'tone counting vs baseline');
        end
    end
end