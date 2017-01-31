%==========================================================================
%This function displays an NIDM_Results pack in a html format. It takes in
%one argument:
%
%jsonfilepath - the filepath to the NIDM-Results json file.
%conInstruct - instructions for which contrast to display.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function webID = nidm_results_display(jsonfilepath, conInstruct)
    
    %Check input
    narginchk(1, 2);

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
        %If there's instructs for which contrast to view use them.
        if(nargin>1)
            if(ischar(conInstruct))
                if(strcmp(conInstruct, 'all'))
                    vec = 1:length(excursionSetMaps);
                end
            else
                vec = conInstruct;
            end
        %Otherwise ask the user.
        else
            %Find the title of each excursion set.
            titles = {};
            for(i = 1:length(excursionSetMaps))
                inference = searchforID(excursionSetMaps{i}.prov_wasGeneratedBy.x_id, graph);
                used = inference.prov_used;
                for(j = 1:length(used))
                    node = searchforID(used(j).x_id,graph);
                    if(isfield(node, 'nidm_effectDegreesOfFreedom'))
                        statisticMap = node;
                        titles{i} = statisticMap.nidm_contrastName;
                    end
                end
            end
            
            %Ask the user which excursion sets they would like to view.
            [vec,selectedAny] = listdlg('PromptString','Select the excursions sets you would like to view:',...
                    'SelectionMode','multiple',...
                    'ListString',titles);
            if(~selectedAny)
                vec = 1:length(excursionSetMaps);
            end 
        end
        %Otherwise generate the labels hashmap and generate a result for
        %each excursion set.
        labels = addExcursionPointers(graph);
        webID = [];
        for(i = vec)
            webID = [spm_results_export(changeNIDMtoSPM(graph,filepathTemp, {i, labels}),...
                                   changeNIDMtoxSPM(graph, filepathTemp, {i, labels}),...
                                   changeNIDMtoTabDat(graph,{i, labels}),...
                                   i) webID];
        end 
    end
    
end