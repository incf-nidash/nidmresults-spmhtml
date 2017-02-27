%==========================================================================
%Search the graph stored inside an NIDM-Results json for an object with a
%given ID. This function takes in two inputs:
%
%ID - The ID to look for.
%graph - The graph to search.
%ids - a list of all ID's in the graph 
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function result = searchforID(ID, graph, ids) 

    result = graph{find(strcmp(ids, ID))};
    
end