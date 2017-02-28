%==========================================================================
%This function displays an NIDM_Results pack in a html format. It takes in
%two arguments:
%
%filepath - thenidmfilepath to the NIDM-Results pack.
%conInstruct - instructions for which contrast to display.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function webID = nidm_results_display(nidmfilepath, conInstruct)
    
    %Check input
    narginchk(1, 2);
    
    %If it is zipped unzip it.
    if contains(nidmfilepath, '.zip')
        [path, filename] = fileparts(nidmfilepath);
%         unzip(nidmfilepath, fullfile(path, filename));
        nidmfilepath = fullfile(path, filename);
    end
    
    try
        jsonfilepath = fullfile(nidmfilepath, 'nidm.jsonld');
        %Record users choice and jsonfilepath.
        jsondoc=spm_jsonread(jsonfilepath);
    catch
        jsonfilepath = fullfile(nidmfilepath, 'nidm.json');
        %Record users choice and jsonfilepath.
        jsondoc=spm_jsonread(jsonfilepath);
    end

    %Add path to required methods
    if exist('changeNIDMtoSPM') ~= 2
        addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'));
    end
    
    % Deal with sub-graphs (bundle)
    if ~iscell(jsondoc)
        graph = jsondoc.x_graph;
        if isfield(graph{2}, 'x_graph')
            graph = graph{2}.x_graph;
        end
    else
        graph = jsondoc;
        graph = graph{2}.x_graph;
    end
    
    %Obtain the type hashmap.
    typemap = addTypePointers(graph);
    
    graphTemp = {};
    for i = 1:length(graph)
        if isfield(graph{i}, 'x_id')
            graphTemp{end+1} = graph{i};
        end
    end
    graph = graphTemp;
    
    %Create the ID list.
    ids = cellfun(@(x) get_value(x.('x_id')), graph, 'UniformOutput', false);
    
    %Work out how many excursion set maps there are to display.
    excursionSetMaps = typemap('nidm_ExcursionSetMap');
    
    %If there is only one excursion set display it. 
    if length(excursionSetMaps)==1
        %Display the page and obtain the pages ID.
        webID = spm_results_export(changeNIDMtoSPM(graph,nidmfilepath,typemap,ids),...
                                   changeNIDMtoxSPM(graph,nidmfilepath,typemap,ids),...
                                   changeNIDMtoTabDat(graph,typemap,ids));
    else
        %If there's instructions for which contrast to view use them.
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
        labels = addExcursionPointers(graph, ids, typemap);
        
        webID = [];
        for(i = vec)
            exID = excursionSetMaps{i}.x_id;
            webID = [spm_results_export(changeNIDMtoSPM(graph,nidmfilepath, typemap, ids, {exID, labels}),...
                                   changeNIDMtoxSPM(graph,nidmfilepath, typemap, ids, {exID, labels}),...
                                   changeNIDMtoTabDat(graph, typemap, ids, {exID, labels}),...
                                   i) webID];
        end 
    end
    
end