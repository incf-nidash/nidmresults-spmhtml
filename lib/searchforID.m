function result = searchforID(ID, graph) 
	for k = 1:length(graph)
		if strcmp(graph{k}.('@id'), ID) 
			result = graph{k};
        end
    end