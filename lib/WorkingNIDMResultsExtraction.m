aa=spm_jsonread('C:\Users\owner\Documents\Project-NIDASH\NIDMtestpack1.json')
graph = aa.('@graph')

% finding title

temp = searchforType('nidm_ContrastMap', graph)

for i = 1:length(temp)
    if isfield(temp{i}, 'nidm_contrastName')
        name = temp{i}.('nidm_contrastName')
    end
end 

% finding contrast vector

contrastWeightMatrix = searchforType('obo_contrastweightmatrix', graph)
contrastVector = contrastWeightMatrix{1}.('prov:value')

% finding set level p & c

excursionSetMap = searchforType('nidm_ExcursionSetMap', graph)
setP = excursionSetMap{1}.('nidm_pValue').('@value')
setC = excursionSetMap{1}.('nidm_numberOfSupraThresholdClusters').('@value')

% finding cluster level p's, k's & c's:
% The below code creates a hashmap where the key is a cluster's ID and the
% value returned is an array of peaks within that cluster.

clusters = searchforType('nidm_SupraThresholdCluster', graph)
keySet = cellfun(@(x) x.('@id'), clusters, 'UniformOutput', false)
valueSet = []

if length(keySet) > 0
    for i = 1:length(keySet)
        valueSet = [valueSet NaN]
    end
end

clusterPeakMap = containers.Map(keySet, valueSet, 'UniformValues', false)
peaks = searchforType('nidm_Peak', graph)

for i = 1:length(peaks)
    temp = peaks{i}.('prov:wasDerivedFrom').('@id')
    if isa(clusterPeakMap(temp), 'double')
        clusterPeakMap(temp) = peaks{i}
    else
        clusterPeakMap(temp) = [clusterPeakMap(temp) peaks{i}]
    end
end

%Once that has been created, to read a clusters information, say cluster{i}
%simply do the following:

pFWEcorrClusValue = clusters{i}.('nidm_pValueFWER').('@value')
qFDRcorrClusValue = clusters{i}.('nidm_qValueFDR').('@value')
kEValue = clusters{i}.('nidm_clusterSizeInVoxels').('@value')
pUncorrClusValue = clusters{i}.('nidm_pValueUncorrected').('@value')

%To then obtain the peaks for that cluster, go to:

peaksOfClusteri = clusterPeakMap(clusters{i}.('@id'))

%If cluster k has more than one peak: to then obtain the data for peak k of
%cluster i simply do the following:

pFWECorrPeakValue = peaksOfClusteri{k}.('nidm_pValueFWER').('@value')
qFDRCorrPeakValue = peaksOfClusteri{k}.('nidm_qValueFDR').('@value')
TorFValue = peaksOfClusteri{k}.('prov:value').('@value')
zValue = peaksOfClusteri{k}.('nidm_equivalentZStatistic').('@value')
pUncorrPeakValue = peaksOfClusteri{k}.('nidm_pValueUncorrected').('@value')

%Else if the cluster only has one peak just replace peaksOfClusteri{k} with
%peaksOfClusteri. 

%To then obtain the peaks coordinates do the following:

locTemp = peaksOfClusteri{k}.('prov:atLocation').('@id')
locTemp = searchforID(locTemp, graph)

xyzCoords = locTemp.nidm_coordinateVector

%Sidenotes: peaks and clusters still need to be ordered. This hasn't
%accounted for the message saying it shows only peaks 8mm apart or further.

%To find the statistics listed at the bottom of the template do the following:

searchSpaceMaskMap = searchforType('nidm_SearchSpaceMaskMap', graph)

expectedVoxelsPerCluster = searchSpaceMaskMap{1}.('nidm_expectedNumberOfVoxelsPerCluster').('@value')
expectedNumberOfClusters = searchSpaceMaskMap{1}.('nidm_expectedNumberOfClusters').('@value')
FWEp = searchSpaceMaskMap{1}.('nidm_heightCriticalThresholdFWE05').('@value')
FDRp = searchSpaceMaskMap{1}.('nidm_heightCriticalThresholdFDR05').('@value')
FWEc = searchSpaceMaskMap{1}.('spm_smallestSignificantClusterSizeInVoxelsFWE05').('@value')
FDRc = searchSpaceMaskMap{1}.('spm_smallestSignificantClusterSizeInVoxelsFDR05').('@value')

