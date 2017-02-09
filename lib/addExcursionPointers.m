%==========================================================================
%This function takes in an NIDM-Results json and creates a hashmap labelling
%objects with a pointer to their relevant excursion set. The resultant
%hashmap takes in the id of an object from the main NIDM-Results graph and
%outputs a number for it's corresponding ExcursionMap. It does this by
%creating a list of keys (which are ID's of nodes in the NIDM graph) and a
%list of values (which are arrays of integers corresponding to the excursion
%sets each node is associated to).
%
%graph - the graph from an NIDM-Results json.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function labels = addExcursionPointers(graph)
    
    %Create an empty list for the keys and values.
    labelValues = {};
    labelKeys = {};
    
    %Return the excursion set maps.
    excursionSetMaps = searchforType('nidm_ExcursionSetMap',graph);
    
    %For each excursion set map backtrack through recording each object and
    %the excursions set map it was connected to.
    
    %The counter variable keeps track of how many key values have currently
    %been added to the hashmap.
    counter = 1;
    
    for(i = 1:length(excursionSetMaps))
        
        %Add in the excursion set map object.
        labelKeys{counter} = excursionSetMaps{i}.x_id;
        labelValues{counter} = [i];
        counter = counter+1;
        
        %Find the inference object connected to the excursionSetMap.
        inference = searchforID(excursionSetMaps{i}.prov_wasGeneratedBy.x_id, graph);
        if(any(ismember(labelKeys, inference.x_id)))
            index = cellfun(@(y) strcmp(y, inference.x_id), labelKeys, 'UniformOutput', 1);
            index = find(index==1);
            labelValues{index} = [labelValues{index} i];
        else
            labelKeys{counter} = inference.x_id;
            labelValues{counter} = [i];
            counter = counter+1;
        end 
        
        %Obtain the objects used by inference.
        used = inference.prov_used;
        statisticMap = [];
        
        %Obtain the nodes inference has used.
        for(j = 1:length(used))
            
            node = searchforID(used(j).x_id,graph);
            
            %Add the nodes to the label list.
            if(any(ismember(labelKeys, node.x_id)))
                index = cellfun(@(y) strcmp(y, node.x_id), labelKeys, 'UniformOutput', 1);
                index = find(index==1);
                labelValues{index} = [labelValues{index} i];
            else
                labelKeys{counter} = node.x_id;
                labelValues{counter} = [i];
                counter = counter+1;
            end 
            
            %Compute which is the statistic map.
            if(isfield(node, 'nidm_effectDegreesOfFreedom'))
                statisticMap = node;
            end
            
        end
        
        %Find the contrast estimate.
        conEst = searchforID(statisticMap.prov_wasGeneratedBy.x_id, graph);
        if(any(ismember(labelKeys, conEst.x_id)))
            index = cellfun(@(y) strcmp(y, conEst.x_id), labelKeys, 'UniformOutput', 1);
            index = find(index==1);
            labelValues{index} = [labelValues{index} i];
        else
            labelKeys{counter} = conEst.x_id;
            labelValues{counter} = [i];
            counter = counter+1;
        end 

        %Obtain the objects used by inference.
        used = conEst.prov_used;
        
        for(j = 1:length(used))
            
            node = searchforID(used(j).x_id,graph);
            
            %Add the nodes to the label list.
            if(any(ismember(labelKeys, node.x_id)))
                index = cellfun(@(y) strcmp(y, node.x_id), labelKeys, 'UniformOutput', 1);
                index = find(index==1);
                labelValues{index} = [labelValues{index} i];
            else
                labelKeys{counter} = node.x_id;
                labelValues{counter} = [i];
                counter=counter+1;
            end 
        end
        
    end
    
    %Now we check which searchSpaceMaskMap was derived from the same
    %inference as which excursionSetMap.
    searchSpaceMaskMaps = searchforType('nidm_SearchSpaceMaskMap',graph);
    
    for(i = 1:length(searchSpaceMaskMaps))
        for(j = 1:length(excursionSetMaps))
            if(strcmp(excursionSetMaps{j}.prov_wasGeneratedBy.x_id,...
                    searchSpaceMaskMaps{i}.prov_wasGeneratedBy.x_id))
                
                if(any(ismember(labelKeys, searchSpaceMaskMaps{i}.x_id)))
                    index = cellfun(@(y) strcmp(y, searchSpaceMaskMaps{i}.x_id), labelKeys, 'UniformOutput', 1);
                    index = find(index==1);
                    labelValues{index} = [labelValues{index} j];
                else
                    labelKeys{counter} = searchSpaceMaskMaps{i}.x_id;
                    labelValues{counter} = [j];
                    counter=counter+1;
                end 
                
            end
        end
    end
    
    %Account for keys listed multiple times.
    
    labels = containers.Map(labelKeys, labelValues, 'UniformValues', false);
    
end