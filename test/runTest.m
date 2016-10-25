function runTest()
    import matlab.unittest.TestSuite;
    tests = matlab.unittest.TestSuite.fromFile(which('nidmExampleDataTest'));
    result = run(tests)
end