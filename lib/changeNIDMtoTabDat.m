function NTabDat = changeNIDMtoTabDat(json)
    
    graph = json.('@graph')
    NTabDat = struct
    
    %====================================
    %tit
    
    titleTemp = 'p-values adjusted for search volume'
    
    %====================================
    %dat
    
    tableTemp = cell(1)
    
    %Set-level:
    
    excursionSetMap = searchforType('nidm_ExcursionSetMap', graph)
    tableTemp{1, 1} = str2double(excursionSetMap{1}.('nidm_pValue').('@value'))
    tableTemp{1, 2} = str2double(excursionSetMap{1}.('nidm_numberOfSupraThresholdClusters').('@value'))
    
    %Cluster and peak level:
    
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
    
    %Read data from map
    
    n = 1
    for i = 1:length(keySet)
        tableTemp{n, 3} = str2double(clusters{i}.('nidm_pValueFWER').('@value'))
        tableTemp{n, 4} = str2double(clusters{i}.('nidm_qValueFDR').('@value'))
        tableTemp{n, 5} = str2double(clusters{i}.('nidm_clusterSizeInVoxels').('@value'))
        tableTemp{n, 6} = str2double(clusters{i}.('nidm_pValueUncorrected').('@value'))
        
        peaksTemp = clusterPeakMap(keySet{i})
        
       for j = 1:min(3, length(peaksTemp))
          tableTemp{n, 7} = str2double(peaksTemp{j}.('nidm_pValueFWER').('@value'))
          tableTemp{n, 8} = str2double(peaksTemp{j}.('nidm_qValueFDR').('@value'))
          tableTemp{n, 9} = str2double(peaksTemp{j}.('prov:value').('@value'))
          tableTemp{n, 10} = str2double(peaksTemp{j}.('nidm_equivalentZStatistic').('@value'))
          tableTemp{n, 11} = str2double(peaksTemp{j}.('nidm_pValueUncorrected').('@value'))
          locTemp = peaksTemp{j}.('prov:atLocation').('@id')
          locTemp = searchforID(locTemp, graph)
          tableTemp{n, 12} = str2num(locTemp.nidm_coordinateVector)
          n = n+1
       end
    end
    
    %==========================================
    %ftr field
   
    ftrTemp = cell(1)
    
    %Height thresholds
    heightThresholds = searchforType('nidm_HeightThreshold', graph)
    hPositions = getThresholdPositions(heightThresholds)
    h1 = str2num(heightThresholds{hPositions(4)}.('prov:value').('@value'))
    h2 = str2num(heightThresholds{hPositions(3)}.('prov:value').('@value'))
    if hPositions(2) ~= 0
        h3 = str2num(heightThresholds{hPositions(2)}.('prov:value').('@value'))
    end
    if hPositions(1) ~= 0
        h3 = str2num(heightThresholds{hPositions(1)}.('prov:value').('@value'))
    end
    
    ftrTemp{1, 1} = 'Height threshold: T = %0.2f, p = %0.3f (%0.3f)'
    ftrTemp{1, 2} = [h1, h2, h3]
    
    %Extent Threshold
    
    extentThresholds = searchforType('nidm_ExtentThreshold', graph)
    ePositions = getThresholdPositions(extentThresholds)
    ftrTemp{2, 1} = 'Extent threshold: k = %0.0f voxels'  
    ftrTemp{2, 2} = str2num(extentThresholds{ePositions(4)}.('nidm_clusterSizeInVoxels').('@value'))
    
    searchSpaceMaskMap = searchforType('nidm_SearchSpaceMaskMap', graph)
    
    %Expected voxels per cluster (k)
    
    ftrTemp{3, 1} = 'Expected voxels per cluster, <k> = %0.3f'
    ftrTemp{3, 2} = str2num(searchSpaceMaskMap{1}.('nidm_expectedNumberOfVoxelsPerCluster').('@value'))
    
    %Expected number of clusters (c)
    
    ftrTemp{4, 1} = 'Expected number of clusters, <c> = %0.2f'  
    ftrTemp{4, 2} = str2num(searchSpaceMaskMap{1}.('nidm_expectedNumberOfClusters').('@value'))
    
    % FWEp, FDRp, FWEc, FDRc
    
    FWEp = str2num(searchSpaceMaskMap{1}.('nidm_heightCriticalThresholdFWE05').('@value'))
    FDRp = str2num(searchSpaceMaskMap{1}.('nidm_heightCriticalThresholdFDR05').('@value'))
    FWEc = str2num(searchSpaceMaskMap{1}.('spm_smallestSignificantClusterSizeInVoxelsFWE05').('@value'))
    FDRc = str2num(searchSpaceMaskMap{1}.('spm_smallestSignificantClusterSizeInVoxelsFDR05').('@value'))
    
    ftrTemp{5,1} = 'FWEp: %0.3f, FDRp: %0.3f, FWEc: %0.0f, FDRc: %0.0f'
    ftrTemp{5,2} = [FWEp, FDRp, FWEc, FDRc]
    
    %Degrees of freedom
    temp = searchforType('nidm_StatisticMap', graph)
    ftrTemp{6,1} = 'Degrees of freedom = [%0.1f, %0.1f]'
    for i = 1:length(temp)
        if isfield(temp{i}, 'nidm_effectDegreesOfFreedom')
            effectDegrees = temp{i}.('nidm_effectDegreesOfFreedom').('@value')
            errorDegrees = temp{i}.('nidm_errorDegreesOfFreedom').('@value')
            ftrTemp{6,2} = [str2num(effectDegrees),  str2num(errorDegrees)]
        end
    end 
    
    %FWHM
    
    temp = searchforID(searchSpaceMaskMap{1}.nidm_inCoordinateSpace.('@id'), graph)
    FWHMUnits = strrep(strrep(strrep(strrep(temp.('nidm_voxelUnits'), '\"', ''), '[', ''), ']', ''), ',', '')
    
    ftrTemp{7, 1} = ['FWHM = %3.1f %3.1f %3.1f ', FWHMUnits '; %3.1f %3.1f %3.1f {voxels}']
    
    unitsFWHM = str2num(searchSpaceMaskMap{1}.('nidm_noiseFWHMInUnits'))
    voxelsFWHM = str2num(searchSpaceMaskMap{1}.('nidm_noiseFWHMInVoxels'))
    
    ftrTemp{7,2} = [unitsFWHM, voxelsFWHM]
    
    %Volume
    
    volumeUnits = str2num(searchSpaceMaskMap{1}.('nidm_searchVolumeInUnits').('@value'))
    volumeResels = str2num(searchSpaceMaskMap{1}.('nidm_searchVolumeInResels').('@value'))
    volumeVoxels = str2num(searchSpaceMaskMap{1}.('nidm_searchVolumeInVoxels').('@value'))
    
    ftrTemp{8, 1} = 'Volume: %0.0f = %0.0f voxels = %0.1f resels' 
    ftrTemp{8, 2} = [volumeUnits, volumeVoxels, volumeResels]
    
    %Voxel dimensions and resel size
    
    temp = searchforID(searchSpaceMaskMap{1}.('nidm_inCoordinateSpace').('@id'), graph)
    voxelSize = str2num(temp.('nidm_voxelSize'))
    voxelUnits = strrep(strrep(strrep(strrep(temp.('nidm_voxelUnits'), '\"', ''), '[', ''), ']', ''), ',', '')
    reselSize = str2num(searchSpaceMaskMap{1}.('nidm_reselSizeInVoxels').('@value'))
    
    ftrTemp{9, 1} = ['Voxel size: %3.1f %3.1f %3.1f ', voxelUnits, '; (resel = %0.2f voxels)']
    ftrTemp{9, 2} = [voxelSize reselSize]
    
    %===========================================
    %str field
    
    temp = searchforType('nidm_PeakDefinitionCriteria', graph)
    units = strtok(voxelUnits, ' ')
    strTemp = ['table shows 3 local maxima more than ', temp{1}.nidm_minDistanceBetweenPeaks.('@value'), units, ' apart']
    
    %===========================================
    %fmt
    
    fmtTemp = {'%-0.3f' '%g' '%0.3f' '%0.3f' '%0.0f' '%0.3f' '%0.3f' '%0.3f' '%6.2f' '%5.2f' '%0.3f' '%3.0f %3.0f %3.0f '}
    
    %=============================================
    
    NTabDat.tit = titleTemp
    NTabDat.dat = tableTemp
    NTabDat.ftr = ftrTemp
    NTabDat.str = strTemp
    NTabDat.fmt = fmtTemp
end