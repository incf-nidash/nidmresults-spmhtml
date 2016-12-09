%==========================================================================
%This function displays an NIDM_Results pack in a html format. It takes in
%one argument:
%
%jsonfilepath - the filepath to the NIDM-Results json file.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function webID = nidm_results_display(jsonfilepath)
    
    %Check input
    narginchk(1, 1);

    %Record users choice and filepath.
    jsondoc=spm_jsonread(jsonfilepath);
    [pathstr, str] = fileparts(jsonfilepath);
    
    %We expect the files for the nidm pack to be stored in a folder, of the
    %same name, located next to the jsons folder.
    jsondoc.filepath = fullfile(pathstr, '..', str);

    %Add path to required methods
    if exist('changeNIDMtoSPM') ~= 2
        addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'));
    end
    
    graph = jsondoc.('x_graph');
    if iscell(graph)
        % Sub-graphs
        graph = graph{2}.('x_graph');
    end

    filepathTemp = jsondoc.filepath;

    %Display the page and obtain the pages ID.
    webID = spm_results_export(changeNIDMtoSPM(graph,filepathTemp),changeNIDMtoxSPM(graph, filepathTemp),changeNIDMtoTabDat(graph));
    
end