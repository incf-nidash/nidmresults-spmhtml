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
    
    % Deal with sub-graphs (bundle)
    if isfield(graph{2}, 'x_graph')
        graph = graph{2}.x_graph;
    end

    filepathTemp = jsondoc.filepath;
    
    %Work out how many excursion set maps there are to display.
    excursionSetMaps = searchforType('nidm_ExcursionSetMap',graph);
    
    %If there is only one excursion set display it. 
    if length(excursionSetMaps)==1
        %Display the page and obtain the pages ID.
        webID = spm_results_export(changeNIDMtoSPM(graph,filepathTemp),...
                                   changeNIDMtoxSPM(graph, filepathTemp),...
                                   changeNIDMtoTabDat(graph));
    else
        %Otherwise generate the labels hashmap and generate a result for
        %each excursion set.
        labels = addExcursionPointers(graph);
        webID = [];
        for(i = 1:length(excursionSetMaps))
            webID = [spm_results_export(changeNIDMtoSPM(graph,filepathTemp, {i, labels}),...
                                   changeNIDMtoxSPM(graph, filepathTemp, {i, labels}),...
                                   changeNIDMtoTabDat(graph,{i, labels}),...
                                   i) webID];
        end 
    end
    
end