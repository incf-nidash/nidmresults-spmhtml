function runTest()
    import matlab.unittest.TestSuite;
    clear classes;
    tests = matlab.unittest.TestSuite.fromFile(which('nidmExampleDataTest'));
    result = run(tests)
end