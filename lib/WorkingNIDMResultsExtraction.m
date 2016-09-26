aa=spm_jsonread('C:\Users\owner\Documents\Project - NIDASH\NIDMtestpack1.json')
graph = aa.('@graph')

% finding title

temp = searchforTag('nidm_ContrastMap', graph)

for i = 1:length(temp)
    if isfield(temp{i}, 'nidm_contrastName')
        name = temp{i}.('nidm_contrastName')
    end
end 

% finding contrast vector

contrastWeightMatrix = searchforTag('obo_contrastweightmatrix', graph)
contrastVector = contrastWeightMatrix{1}.('prov:value')

% finding set level p & c

excursionSetMap = searchforTag('nidm_ExcursionSetMap', graph)
setP = excursionSetMap{1}.('nidm_pValue').('@value')
setC = excursionSetMap{1}.('nidm_numberOfSupraThresholdClusters').('@value')

% finding cluster level p's, k's & c's
