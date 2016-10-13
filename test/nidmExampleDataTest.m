classdef nidmExampleDataTest < matlab.unittest.TestCase
    methods(Test)
        function checkViewerRuns(testCase)
            nidm_results_display(strrep(fileparts(mfilename('fullpath'), 'Test', 'Data\nidm.json'))
        end
        
        function checkTitlePresent(testCase)
        
    end
end