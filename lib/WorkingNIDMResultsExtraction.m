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

% finding height thresholds
heightThresholds = searchforType('nidm_HeightThreshold', graph)

FDR = 0
FWE = 0
for i = 1:length(heightThresholds)
    if any(ismember(heightThresholds{i}.('@type'), 'obo_FWERadjustedpvalue'))
        FWE = i
    end
    if any(ismember(heightThresholds{i}.('@type'), 'obo_FDRadjustedqvalue'))
        FDR = i
    end
    if any(ismember(heightThresholds{i}.('@type'), 'nidm_PValueUncorrected'))
        unCorr = i
    end
    if any(ismember(heightThresholds{i}.('@type'), 'obo_statistic'))
        stat = i
    end
end

if FWE ~= 0
    probabilityHeightThreshold = heightThresholds{FWE}.('prov:value').('@value')
    type = 'FWE'
elseif FDR ~= 0
    probabilityHeightThreshold = heightThresholds{FDR}.('prov:value').('@value')
    type = 'FDR'
else
    probabilityHeightThreshold = heightThresholds{unCorr}.('prov:value').('@value')
    type = 'uncorr'
end

statisticHeightThreshold = heightThresholds{stat}.('prov:value').('@value')

%At the top of the template the statisticHeightThreshold and probabilityHeightThreshold and displayed
%with the text detailing what 'type's they are.

%At the bottom all assigned thresholds are displayed (including the statisticHeightThreshold above:

if FWE ~= 0
    probabilityHeightThresholdFWE = heightThresholds{FWE}.('prov:value').('@value')
end
if FDR ~= 0
    probabilityHeightThresholdFDR = heightThresholds{FDR}.('prov:value').('@value')
end
if unCorr ~= 0
    probabilityHeightThresholdUnCorr = heightThresholds{unCorr}.('prov:value').('@value')
end

% finding set level p & c

excursionSetMap = searchforType('nidm_ExcursionSetMap', graph)
setP = excursionSetMap{1}.('nidm_pValue').('@value')
setC = excursionSetMap{1}.('nidm_numberOfSupraThresholdClusters').('@value')

% finding cluster level p's, k's & c's:
% The below code creates a hashmap where the key is a cluster's ID and the
% value returned is an array of peaks within that cluster.

clusters = searchforType('nidm_SupraThresholdCluster', graph)

%Sorting the clusters by descending size.
oo=cellfun(@(x) x.('nidm_clusterSizeInVoxels').('@value'), clusters, 'UniformOutput', false);
aa=str2num(strvcat(oo{:}))
[unused, idx]=sort(aa, 'descend')
clusters = clusters(idx)

%Create keySet and valueSet
keySet = cellfun(@(x) x.('@id'), clusters, 'UniformOutput', false)
valueSet = repmat(NaN, 1, length(keySet));

clusterPeakMap = containers.Map(keySet, valueSet, 'UniformValues', false)
peaks = searchforType('nidm_Peak', graph)

for i = 1:length(peaks)
    temp = peaks{i}.('prov:wasDerivedFrom').('@id')
    if isa(clusterPeakMap(temp), 'double')
        clusterPeakMap(temp) = {peaks{i}}
    else
        existing = clusterPeakMap(temp);
        clusterPeakMap(temp) = {existing{:} peaks{i}}
    end
end

%Sorting the peaks within clusters.
for i = 1:length(keySet)
    temp = keySet{i}
    clustmaptemp=clusterPeakMap(temp)
    oo=cellfun(@(x) x.('prov:value').('@value'), clustmaptemp, 'UniformOutput', false);
    aa=str2num(strvcat(oo{:}))
    [unused, idx]=sort(aa, 'descend')
    clusterPeakMap(temp) = clustmaptemp(idx)
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
unitsFWHM = searchSpaceMaskMap{1}.('nidm_noiseFWHMInUnits')
voxelsFWHM = searchSpaceMaskMap{1}.('nidm_noiseFWHMInVoxels')
volumeUnits = searchSpaceMaskMap{1}.('nidm_searchVolumeInUnits').('@value') 
volumeResels = searchSpaceMaskMap{1}.('nidm_searchVolumeInResels').('@value')
volumeVoxels = searchSpaceMaskMap{1}.('nidm_searchVolumeInVoxels').('@value')
reselSize = searchSpaceMaskMap{1}.('nidm_reselSizeInVoxels').('@value')

%For voxel size
temp = searchforID(searchSpaceMaskMap{1}.('nidm_inCoordinateSpace').('@id'))
voxelSize = temp.('nidm_voxelSize')
voxelUnits = temp.('nidm_voxelUnits')

%For degrees of freedom
temp = searchforType('nidm_StatisticMap', graph)
for i = 1:length(temp)
    if isfield(temp{i}, 'nidm_effectDegreesOfFreedom')
        effectDegrees = temp{i}.('nidm_effectDegreesOfFreedom').('@value')
        errorDegrees = temp{i}.('nidm_errorDegreesOfFreedom').('@value')
        degreesOfFreedom = [str2num(effectDegrees),  str2num(errorDegrees)]
    end
end 

