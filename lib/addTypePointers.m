%==========================================================================
%This function takes in an NIDM-Results json and creates a hashmap labelling
%object types with their corresponding object. It takes in one argument:
%
%graph - the graph from an NIDM-Results json.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function typemap = addTypePointers(graph)
    
    keys_objType = {};
    values_objIDs = {};
    
    %Look through the graph recording types for each object.
    for i = 1:length(graph)
        types = graph{i}.x_type;
        if isa(types, 'char')
            types = {types};
        end
        
        %Record all objects types.
        for j = 1:length(types)
            typej = types{j};
            %Check if the type already exists in the hashmap.
            if any(ismember(keys_objType, typej))
                %Find where the type is already stored.
                index = cellfun(@(y) strcmp(y, typej), keys_objType, 'UniformOutput', 1);
                index = find(index==1);
                %Add the object's ID to the list of objects of type j.
                tempIDs = values_objIDs{index};
                tempIDs{end+1} = graph{i};
                values_objIDs{index} = tempIDs;
            %Otherwise add the type to the hashmap.
            else
                keys_objType{end+1} = typej;
                values_objIDs{end+1} = {graph{i}};
            end 
        end
    end
    typemap = containers.Map(keys_objType, values_objIDs, 'UniformValues', false);
end
