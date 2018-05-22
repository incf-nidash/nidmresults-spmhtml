%==========================================================================
%Unit tests for testing features of the viewer. To run the below run the 
%runTest function.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function test_suite=testFeatures2
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

%Function for deleting any HTML generated previously by the viewer
function delete_html_file(data_path)
    index = fullfile(data_path,'index.html');
    if exist(index, 'file')
       delete(index);
    else
        for(i = 1:8)
            index = fullfile(data_path,['index', num2str(i), '.html']);
            if exist(index, 'file')
                delete(index);
            end
        end
    end
end

%testing the viewer runs on SPM-nidm input.
function testViewerRunsSPM()
    data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_default.nidm');
    delete_html_file(data_path);
    nidm_results_display(data_path);
end

%testing the experiment title is somewhere in the output HTML
%file.
function testForTitle()
    data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_default.nidm');
    delete_html_file(data_path);
    nidm_results_display(data_path);
    text = fileread(fullfile(data_path, 'index.html'));
    verifySubstring(text, 'tone counting vs baseline');
end

%testing the original functionality of the viewer with the
%original SPM, xSPM and TabDat functions is unaffected.
function testOriginalViewerRuns()
    data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_output');
    delete_html_file(data_path);
    cwd = pwd;
    cd(data_path)
    testData = load(fullfile(data_path, 'nidm_example001.mat'));
    spm_results_export(testData.SPM, testData.xSPM, testData.TabDat);
    cd(cwd);
end

%testing the viewer runs on FSL-nidm output.
function testViewerRunsFSL()
    data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'fsl_default_130.nidm');
    delete_html_file(data_path);
    nidm_results_display(data_path);
end

%testing the viewer runs on SPM-nidm output with no MIP.
function testViewerRunsSPMwoMIP()
    data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_default_wo_MIP');
    %Copy contents of ex_spm_default NIDM pack.
    copyfile(fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_default.nidm', '*'),...
        fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_default_wo_MIP'));
    %Delete the pre-existing jsonld.
    delete(fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_default_wo_MIP', 'nidm.jsonld'));
    %Copy the jsonld without the MIP into the NIDM pack.
    copyfile(fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'testJsons', 'nidm.json'), fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_default_wo_MIP'));
    %Run the test.
    delete_html_file(data_path);
    nidm_results_display(data_path);
end
        
%         %testing the nidm json is not damaged by the viewer.
%         function testNIDMUnaffected()
%             fsl_default_dir = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'fsl_default');
%             delete_html_file(fsl_default_dir);
%             nidm_results_display(fullfile(fsl_default_dir, 'nidm.json'));
%             originalNIDM = spm_jsonread(fullfile(fsl_default_dir, 'nidmWithoutMip.json'));
%             currentNIDM = spm_jsonread(fullfile(fsl_default_dir, 'nidm.json'));
%             %Choose a random vertex in the graph that we know should not have been changed.
%             testObject = 20;
%             while testObject == 20
%                 testObject = randi(length(originalNIDM.x_graph));
%             end
%             verifyEqual(currentNIDM.x_graph{testObject}, originalNIDM.x_graph{testObject});
%         end
