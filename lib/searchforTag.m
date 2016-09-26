function result = searchforTag(tag, graph) 
 
    result = []
    n = 1
    for k = 1:331
        if any(ismember(graph{k}.('@type'), tag)) && isa(graph{k}.('@type'), 'cell')
            result{n} = graph{k}
            n = n+1
        end
        if isa(graph{k}.('@type'), 'char')
            if strcmp(graph{k}.('@type'), tag)
                result{n} = graph{k}
                n = n+1
            end
        end
    end
end
