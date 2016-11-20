%==========================================================================
%This function runs the testFeatures tests, which test specific features of
%the viewer, and the testDataSets tests, which test all datasets available in the
%file.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function runTest()
    
    %Setup steps for the test.
    import matlab.unittest.TestSuite;
    clear classes;
    
    %Create the testDataSets tests.
    createTest();
    
    %Run all tests.
    tests = [matlab.unittest.TestSuite.fromFile(which('testDataSets')),...
             matlab.unittest.TestSuite.fromFile(which('testFeatures'))];
    result = run(tests)
    
end