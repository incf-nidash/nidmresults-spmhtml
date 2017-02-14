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
    values_excNum = {};
    keys_objId = {};
    
    keys_type = {};
    values_objIds = {};
    
    %Return the excursion set maps.
    excursionSetMaps = searchforType('nidm_ExcursionSetMap',graph);
    
    %For each excursion set map backtrack through recording each object and
    %the excursions set map it was connected to.
    
    %The counter variable keeps track of how many key values have currently
    %been added to the hashmap.
    counter = 1;
    
    for(i = 1:length(excursionSetMaps))
        
        %Add in the excursion set map object.
        keys_objId{counter} = excursionSetMaps{i}.x_id;
        values_excNum{counter} = [i];
    
        keys_type{counter} = 'nidm_ExcursionSetMap';
        values_objIds{counter} = [values_objIds{counter} excursionSetMaps{i}.x_id];
        
        counter = counter+1;        
        
        %Find the inference object connected to the excursionSetMap.
        inference = searchforID(excursionSetMaps{i}.prov_wasGeneratedBy.x_id, graph);
        if(any(ismember(keys_objId, inference.x_id)))
            index = cellfun(@(y) strcmp(y, inference.x_id), keys_objId, 'UniformOutput', 1);
            index = find(index==1);
            values_excNum{index} = [values_excNum{index} i];
        else
            keys_objId{counter} = inference.x_id;
            values_excNum{counter} = [i];
            counter = counter+1;
        end 
        
        keys_type{counter} = 'nidm_Inference';
        values_objIds{counter} = [values_objIds{counter} excursionSetMaps{i}.x_id];
        
        %Obtain the objects used by inference.
        used = inference.prov_used;
        statisticMap = [];
        
        %Obtain the nodes inference has used.
        for(j = 1:length(used))
            
            node = searchforID(used(j).x_id,graph);
            
            %Add the nodes to the label list.
            if(any(ismember(keys_objId, node.x_id)))
                index = cellfun(@(y) strcmp(y, node.x_id), keys_objId, 'UniformOutput', 1);
                index = find(index==1);
                values_excNum{index} = [values_excNum{index} i];
            else
                keys_objId{counter} = node.x_id;
                values_excNum{counter} = [i];
                counter = counter+1;
            end 
            
            %Compute which is the statistic map.
            if(isfield(node, 'nidm_effectDegreesOfFreedom'))
                statisticMap = node;
            end
            
        end
        
        %Find the contrast estimate.
        conEst = searchforID(statisticMap.prov_wasGeneratedBy.x_id, graph);
        if(any(ismember(keys_objId, conEst.x_id)))
            index = cellfun(@(y) strcmp(y, conEst.x_id), keys_objId, 'UniformOutput', 1);
            index = find(index==1);
            values_excNum{index} = [values_excNum{index} i];
        else
            keys_objId{counter} = conEst.x_id;
            values_excNum{counter} = [i];
            counter = counter+1;
        end 

        %Obtain the objects used by inference.
        used = conEst.prov_used;
        
        for(j = 1:length(used))
            
            node = searchforID(used(j).x_id,graph);
            
            %Add the nodes to the label list.
            if(any(ismember(keys_objId, node.x_id)))
                index = cellfun(@(y) strcmp(y, node.x_id), keys_objId, 'UniformOutput', 1);
                index = find(index==1);
                values_excNum{index} = [values_excNum{index} i];
            else
                keys_objId{counter} = node.x_id;
                values_excNum{counter} = [i];
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
                
                if(any(ismember(keys_objId, searchSpaceMaskMaps{i}.x_id)))
                    index = cellfun(@(y) strcmp(y, searchSpaceMaskMaps{i}.x_id), keys_objId, 'UniformOutput', 1);
                    index = find(index==1);
                    values_excNum{index} = [values_excNum{index} j];
                else
                    keys_objId{counter} = searchSpaceMaskMaps{i}.x_id;
                    values_excNum{counter} = [j];
                    counter=counter+1;
                end 
                
            end
        end
    end
    
    %Account for keys listed multiple times.
    
    labels = containers.Map(keys_objId, values_excNum, 'UniformValues', false);
    
end