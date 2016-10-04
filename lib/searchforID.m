function result = searchforID(ID, graph) 
	for k = 1:length(graph)
		if strcmp(graph{k}.('x_id'), ID) 
			result = graph{k};
        end
    end