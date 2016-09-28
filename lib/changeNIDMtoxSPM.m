
function NxSPM = changeNIDMtoxSPM(xSPM, json)
    
    graph = json.('@graph')
    NxSPM = xSPM
    
    %==============================================
    %Retrieve title
    temp = searchforType('nidm_ContrastMap', graph)
    name = []
    for i = 1:length(temp)
        if isfield(temp{i}, 'nidm_contrastName')
            name = temp{i}.('nidm_contrastName')
        end
    end 
    NxSPM.title = name
    
    %==============================================
    %Retrieve
    
end