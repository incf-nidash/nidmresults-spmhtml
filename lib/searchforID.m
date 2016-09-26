function result = searchforID(ID, graph) 
	for k = 1:331
		if strcmp(graph{k}.('@id'), ID) 
			result = graph{k}
        end
    end