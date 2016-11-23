%==========================================================================
%This function runs the testFeatures tests, which test specific features of
%the viewer, and the testDataSets tests, which test all datasets available in the
%file.
%
%-skip - this is a boolean - when true we don't test any jsons that do not
%have corresponding zips stored locally or online, when false we ask the
%user if they can provide information for downloading these zips.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function runTest(skip)

    %If the user didn't specify we assume they wish to skip jsons with no
    %corresponding zip files.
    if nargin < 1
        skip = 1;
    end
    
    %Setup steps for the test.
    import matlab.unittest.TestSuite;
    
    %Create the testDataSets tests.
    createTest(skip);
    
    clear classes;
    
    %Run all tests.
    tests = [matlab.unittest.TestSuite.fromFile(which('testDataSets')),...
             matlab.unittest.TestSuite.fromFile(which('testFeatures'))];
    result = run(tests)
    
end