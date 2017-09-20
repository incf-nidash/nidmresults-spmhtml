%==========================================================================
%This function displays an NIDM_Results pack in a html format. It takes in
%three arguments:
%
%filepath - thenidmfilepath to the NIDM-Results pack.
%conInstruct - instructions for which contrasts to display from inside the
%              NIDM-Results(either a vector of indexes (e.g. [1, 2, 4]), 
%              'All' to display all contrasts or 'Man' for manual entry).
%outdir - an output directory for the NIDM-Results pack (optional).
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function webID = nidm_results_display(nidmfilepath, conInstruct, outdir)
        
    spm_progress_bar('Init',10,'Unpacking NIDM-Results','Current stage');
     
    %Check input
    narginchk(1, 3);
    if ~exist('outdir', 'var')
        outdir = '';
    end
    
    %If it is zipped unzip it.
    if contains(nidmfilepath, '.zip')
        [path, filename] = fileparts(nidmfilepath);
        unzip(nidmfilepath, fullfile(path, filename));
        nidmfilepath = fullfile(path, filename);
    end
       
    spm_progress_bar('Set',1);
    
    try
        jsonfilepath = fullfile(nidmfilepath, 'nidm.jsonld');
        %Record users choice and jsonfilepath.
        bugFix(jsonfilepath);
        jsondoc=spm_jsonread(jsonfilepath);
    catch
        jsonfilepath = fullfile(nidmfilepath, 'nidm.json');
        %Record users choice and jsonfilepath.
        jsondoc=spm_jsonread(jsonfilepath);
    end
    
    spm_progress_bar('Set',3);
    
    %Error if there is no json available.
    if(exist(jsonfilepath, 'file')==0) 
        error('Error: JSON serialization not present in NIDM-Results pack.') 
    end
    
    context = load_json_context(jsondoc);

    %Add path to required methods
    if exist('changeNIDMtoSPM', 'file') ~= 2
        addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'));
    end
    
    % Deal with sub-graphs (bundle)
    if ~iscell(jsondoc)
        graph = jsondoc.x_graph;
        spm_progress_bar('Set',4);
        if isfield(graph{2}, 'x_graph')
            graph = graph{2}.x_graph;
        end
    else
        graph = jsondoc;
        spm_progress_bar('Set',4);
        graph = graph{2}.x_graph;
    end
    
    spm_progress_bar('Set',5);
    
    %Obtain the type hashmap.
    typemap = addTypePointers(graph);
    
    spm_progress_bar('Set',7);
    
    graphTemp = {};
    for i = 1:length(graph)
        if isfield(graph{i}, 'x_id')
            graphTemp{end+1} = graph{i};
        end
    end
    graph = graphTemp;
    
    spm_progress_bar('Set',8);
    
    %Create the ID list.
    ids = cellfun(@(x) get_value(x.('x_id')), graph, 'UniformOutput', false);
    
    spm_progress_bar('Set',10);
    spm_progress_bar('Clear');
    
    %Work out how many excursion set maps there are to display.
    excursionSetMaps = typemap('nidm_ExcursionSetMap');
    
    %If there is only one excursion set display it. 
    if length(excursionSetMaps)==1
        %Display the page and obtain the pages ID.
        webID = spm_results_export(changeNIDMtoSPM(graph,nidmfilepath,typemap,context,ids),...
                                   changeNIDMtoxSPM(graph,nidmfilepath,typemap,context,ids),...
                                   changeNIDMtoTabDat(graph,typemap,context,ids), -1, outdir);
    else
        %Otherwise generate the labels hashmap and generate a result for
        %each excursion set.
        labels = addExcursionPointers(graph, ids, typemap);
        
        if strcmp(conInstruct, 'Man')
            
            %If there are no instructions for which contrasts to open we
            %ask the user.
            spm_progress_bar('Init',(length(excursionSetMaps) + 1),'Opening Contrast Window','Current stage');
            
            %First we unpack the SPM objects to work out which contrasts
            %the user should choose between.
            for i = 1:length(excursionSetMaps)
                
                %Retrieve SPM object corresponding to excursion set i.
                exID = excursionSetMaps{i}.x_id;
                SPM = changeNIDMtoSPM(graph,nidmfilepath, typemap, ids, {exID, labels});
                
                %Store all SPM objects as we will use them again when
                %displaying.
                SPMs{i} = SPM;
                
                %These variables are needed to run the contrast selection
                %window.
                xCon(i).name = SPM.xCon.name;   
                xCon(i).STAT = SPM.xCon.STAT; 
                xCon(i).c = SPM.xCon.c;
                spm_progress_bar('Set',i);
            end 
        
            %Open the contrast selection window and ask the user which 
            %contrasts they'd like to see.
            SPM.xCon = xCon;
            spm_progress_bar('Set',(length(excursionSetMaps)+1));
            spm_progress_bar('Clear');
            vec = spm_conman(SPM,'T&F',Inf,'    Select contrasts...',' for conjunction',0);

        elseif strcmp(conInstruct, 'All')
            %Display all contrasts.
            vec = 1:length(excursionSetMaps);
        elseif isnumeric(conInstruct) && max(conInstruct) <= length(excursionSetMaps) && min(conInstruct) > 0
            vec = conInstruct;
        else
            error('Unknown value entered for conInstruct');
        end
        
        %Display said contrasts.
        for i = vec 
            spm_progress_bar('Init',3,['Displaying contrast ', num2str(i)],'Current stage');
            exID = excursionSetMaps{i}.x_id;
           
            spm_progress_bar('Set',1);
            %Generate xSPM and TabDat for this contrast.
            xSPM = changeNIDMtoxSPM(graph,nidmfilepath, typemap, context, ids, {exID, labels});
            spm_progress_bar('Set',2)
            TabDat = changeNIDMtoTabDat(graph, typemap, context, ids, {exID, labels});
            spm_progress_bar('Set',3)
            
            %Open display, using any SPM variables we've calculated
            %already.
            webID = [];
            if exist('SPMs', 'var')
                webID = [spm_results_export(SPMs{i}, xSPM, TabDat, i, outdir) webID];
            else
                webID = [spm_results_export(changeNIDMtoSPM(graph,nidmfilepath, typemap, context, ids, {exID, labels}),...
                        xSPM, TabDat, i, outdir) webID];
            end
        end
    end
    
    spm_progress_bar('Clear');
    
end


%--------------------------------------------------------------------------
%This function is temporary and only here due to a bug in the current SPM
%export leading to additional ':' characters appearing in the jsonld. The
%function and all references to it should be removed during the next spm
%update.
%--------------------------------------------------------------------------
function bugFix(jsonPath)
    %Open the file and read in the text.
    fileID = fopen(jsonPath, 'r+');
    text = fscanf(fileID, '%c', inf);
    
    %Remove the colons.
    text = strrep(text, ':"', '"');
    text = strrep(text, '\n', '\\n');
    text = strrep(text, '\"', '\\"');
    fclose(fileID);
    
    %Print out.
    fileID = fopen(jsonPath, 'wt');
    fprintf(fileID, text);
    fclose(fileID);
end