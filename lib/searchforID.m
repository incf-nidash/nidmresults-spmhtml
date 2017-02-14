%==========================================================================
%Search the graph stored inside an NIDM-Results json for an object with a
%given ID. This function takes in two inputs:
%
%ID - The ID to look for.
%graph - The graph to search.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function result = searchforID(ID, graph, ids) 
%     tic
%     %Search the graph for the results.
% 	for k = 1:length(graph)
% 		if strcmp(graph{k}.('x_id'), ID) 
% 			result = graph{k};
%         end
%     end
%     toc
%     tic
%     
%      tic
% This will have to be done externally:
% ids = cellfun(@(x) get_value(x.('x_id')), graph, 'UniformOutput', false);
    result = graph{find(strcmp(ids, ID))};
%      toc
end