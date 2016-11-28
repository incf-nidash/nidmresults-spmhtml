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
    
    %Create the testDataSets tests.
    createTest();
    
    %Clear all classes we can.
    warning('off','MATLAB:objectStillExists');
    warning('off','MATLAB:ClassInstanceExists');
    clear classes; 
    warning('on','MATLAB:objectStillExists');
    warning('on','MATLAB:ClassInstanceExists');
    
    %Run all tests.
    tests = [matlab.unittest.TestSuite.fromFile(which('testDataSets')),...
             matlab.unittest.TestSuite.fromFile(which('testFeatures'))];
    result = run(tests)
    
end