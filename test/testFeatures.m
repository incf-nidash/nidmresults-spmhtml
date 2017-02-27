%==========================================================================
%Unit tests for testing features of the viewer. To run the below run the 
%runTest function.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

classdef testFeatures < matlab.unittest.TestCase
       
    methods
        %Function for deleting any HTML generated previously by the viewer.
        function delete_html_file(testCase, data_path)
            index = fullfile(data_path, 'index.html');
            if exist(index, 'file')
                delete(index);
            end
        end
    end
        
    methods(Test)
        
        %Checking the viewer runs on SPM-nidm input.
        function checkViewerRunsSPM(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_default');
            if(~exist(data_path, 'dir'))
                mkdir(data_path)
                websave(fullfile(data_path, 'tmp.zip'), 'http://neurovault.org/collections/1692/ex_spm_default.nidm.zip');
                unzip(fullfile(data_path, 'tmp.zip'), fullfile(data_path, '.'));
                
                %Save the download link in the json.
                json = spm_jsonread(fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'jsons', 'ex_spm_default.json'));
                [designMatrix, dmLocation] = searchforType('nidm_DesignMatrix', json.x_graph);  
                designMatrix{1}.prov_atLocation.x_value = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_default', 'DesignMatrix.csv');
                graph = json.x_graph;
                graph{dmLocation{1}} = designMatrix{1};
                json.x_graph = graph;
                spm_jsonwrite(fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'jsons', 'ex_spm_default.json'),json);
            end
            testCase.delete_html_file(data_path);
            nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'jsons', 'ex_spm_default.json'));
        end
        
        %Checking the experiment title is somewhere in the output HTML
        %file.
        function checkForTitle(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_default');
            testCase.delete_html_file(data_path);
            nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'jsons', 'ex_spm_default.json'));
            text = fileread(fullfile(data_path, 'index.html'));
            verifySubstring(testCase, text, 'tone counting vs baseline');
        end
        
        %Checking the original functionality of the viewer with the
        %original SPM, xSPM and TabDat functions is unaffected.
        function checkOriginalViewerRuns(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_output');
            testCase.delete_html_file(data_path);
            cwd = pwd;
            cd(data_path)
            testData = load(fullfile(data_path, 'nidm_example001.mat'));
            spm_results_export(testData.SPM, testData.xSPM, testData.TabDat);
            cd(cwd);
        end
        
        %Checking the viewer runs on FSL-nidm output.
        function checkViewerRunsFSL(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'fsl_default_130');
            testCase.delete_html_file(data_path);
            nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'jsons', 'fsl_default_130.json'));
        end
        
        %Checking the viewer runs on SPM-nidm output with no MIP.
        function checkViewerRunsSPMwoMIP(testCase)
            data_path = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'ex_spm_default');
            testCase.delete_html_file(data_path);
            nidm_results_display(fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'testJsons', 'ex_spm_default.json'));
        end
        
%         %Checking the nidm json is not damaged by the viewer.
%         function checkNIDMUnaffected(testCase)
%             fsl_default_dir = fullfile(fileparts(mfilename('fullpath')), '..', 'test', 'data', 'fsl_default');
%             testCase.delete_html_file(fsl_default_dir);
%             nidm_results_display(fullfile(fsl_default_dir, 'nidm.json'));
%             originalNIDM = spm_jsonread(fullfile(fsl_default_dir, 'nidmWithoutMip.json'));
%             currentNIDM = spm_jsonread(fullfile(fsl_default_dir, 'nidm.json'));
%             %Choose a random vertex in the graph that we know should not have been changed.
%             testObject = 20;
%             while testObject == 20
%                 testObject = randi(length(originalNIDM.x_graph));
%             end
%             verifyEqual(testCase, currentNIDM.x_graph{testObject}, originalNIDM.x_graph{testObject});
%         end

    end
end