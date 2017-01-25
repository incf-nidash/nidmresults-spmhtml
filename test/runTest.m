%==========================================================================
%This function runs the testFeatures tests, which test specific features of
%the viewer, and the testDataSets tests, which test all datasets available in the
%file.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function runTest()
    
    %Clear previous classes.
    clear all;

    %Setup steps for the test.
    import matlab.unittest.TestSuite;
    addpath(fullfile(fileparts(mfilename('fullpath')),'..', 'lib'));
    addpath(fullfile(fileparts(mfilename('fullpath')),'..'));
    
    %Create the testDataSets tests.
    createTest();
    
    %Run all tests.
    tests = [matlab.unittest.TestSuite.fromFile(which('testDataSets')),...
             matlab.unittest.TestSuite.fromFile(which('testFeatures'))];
    result = run(tests)
    
end