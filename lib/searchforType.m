%==========================================================================
%Search the graph stored inside an NIDM-Results json for objects of a given
%type, returning the objects and their indices within the graph. This 
%function takes in two inputs:
%
%ID - The ID to look for.
%graph - The graph to search.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function [result, index] = searchforType(type, graph) 
    
    index = [];
    result = [];
    n = 1;
    
    %Look through the graph for objects of a type 'type'.
    for k = 1:length(graph)
        %If an object has one of its types listed as 'type' recorded it.
        if any(ismember(graph{k}.('x_type'), type)) && isa(graph{k}.('x_type'), 'cell')
            result{n} = graph{k};
            index{n} = k;
            n = n+1;
        end
        %If an object has it's only type listed as 'type' recorded it.
        if isa(graph{k}.('x_type'), 'char')
            if strcmp(graph{k}.('x_type'), type)
                result{n} = graph{k};
                index{n} = k;
                n = n+1;
            end
        end
    end
end
