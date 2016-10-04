function NTabDat = changeNIDMtoTabDat(json)
    
    graph = json.('x_graph');
    NTabDat = struct;
    
    %====================================
    %tit
    
    titleTemp = 'p-values adjusted for search volume';
    
    %====================================
    %dat
    
    tableTemp = cell(1);
    
    %Set-level:
    
    excursionSetMap = searchforType('nidm_ExcursionSetMap', graph);
    tableTemp{1, 1} = str2double(excursionSetMap{1}.('nidm_pValue').('x_value'));
    tableTemp{1, 2} = str2double(excursionSetMap{1}.('nidm_numberOfSupraThresholdClusters').('x_value'));
    
    %Cluster and peak level:
    
    clusters = searchforType('nidm_SupraThresholdCluster', graph);

    %Sorting the clusters by descending size.
    oo=cellfun(@(x) x.('nidm_clusterSizeInVoxels').('x_value'), clusters, 'UniformOutput', false);
    aa=str2num(strvcat(oo{:}));
    [unused, idx]=sort(aa, 'descend');
    clusters = clusters(idx);

    %Create keySet and valueSet
    keySet = cellfun(@(x) x.('x_id'), clusters, 'UniformOutput', false);
    valueSet = repmat(NaN, 1, length(keySet));

    clusterPeakMap = containers.Map(keySet, valueSet, 'UniformValues', false);
    peaks = searchforType('nidm_Peak', graph);

    for i = 1:length(peaks)
        clusterID = peaks{i}.('prov_wasDerivedFrom').('x_id');
        if isa(clusterPeakMap(clusterID), 'double')
            clusterPeakMap(clusterID) = {peaks{i}};
        else
            existing = clusterPeakMap(clusterID);
            clusterPeakMap(clusterID) = {existing{:} peaks{i}};
        end
    end

    %Sorting the peaks within clusters.
    for i = 1:length(keySet)
        clusterID = keySet{i};
        clustmaptemp=clusterPeakMap(clusterID);
        clusSet=cellfun(@(x) x.('prov_value').('x_value'), clustmaptemp, 'UniformOutput', false);
        orderedClusSet=str2num(strvcat(clusSet{:}));
        [unused, idx]=sort(orderedClusSet, 'descend');
        clusterPeakMap(clusterID) = clustmaptemp(idx);
    end
    
    %Read data from map
    
    n = 1;
    for i = 1:length(keySet)
        tableTemp{n, 3} = str2double(clusters{i}.('nidm_pValueFWER').('x_value'));
        tableTemp{n, 4} = str2double(clusters{i}.('nidm_qValueFDR').('x_value'));
        tableTemp{n, 5} = str2double(clusters{i}.('nidm_clusterSizeInVoxels').('x_value'));
        tableTemp{n, 6} = str2double(clusters{i}.('nidm_pValueUncorrected').('x_value'));
        
        peaksTemp = clusterPeakMap(keySet{i});
        
       for j = 1:min(3, length(peaksTemp))
          tableTemp{n, 7} = str2double(peaksTemp{j}.('nidm_pValueFWER').('x_value'));
          tableTemp{n, 8} = str2double(peaksTemp{j}.('nidm_qValueFDR').('x_value'));
          tableTemp{n, 9} = str2double(peaksTemp{j}.('prov_value').('x_value'));
          tableTemp{n, 10} = str2double(peaksTemp{j}.('nidm_equivalentZStatistic').('x_value'));
          tableTemp{n, 11} = str2double(peaksTemp{j}.('nidm_pValueUncorrected').('x_value'));
          locTemp = peaksTemp{j}.('prov_atLocation').('x_id');
          locTemp = searchforID(locTemp, graph);
          tableTemp{n, 12} = str2num(locTemp.nidm_coordinateVector);
          n = n+1;
       end
    end
    
    %==========================================
    %ftr field
   
    ftrTemp = cell(1);
    
    %Height thresholds
    heightThresholds = searchforType('nidm_HeightThreshold', graph);
    hPositions = getThresholdPositions(heightThresholds);
    h1 = str2num(heightThresholds{hPositions(4)}.('prov_value').('x_value'));
    h2 = str2num(heightThresholds{hPositions(3)}.('prov_value').('x_value'));
    if hPositions(2) ~= 0
        h3 = str2num(heightThresholds{hPositions(2)}.('prov_value').('x_value'));
    end
    if hPositions(1) ~= 0
        h3 = str2num(heightThresholds{hPositions(1)}.('prov_value').('x_value'));
    end
    
    ftrTemp{1, 1} = 'Height threshold: T = %0.2f, p = %0.3f (%0.3f)';
    ftrTemp{1, 2} = [h1, h2, h3];
    
    %Extent Threshold
    
    extentThresholds = searchforType('nidm_ExtentThreshold', graph);
    ePositions = getThresholdPositions(extentThresholds);
    ftrTemp{2, 1} = 'Extent threshold: k = %0.0f voxels';  
    ftrTemp{2, 2} = str2num(extentThresholds{ePositions(4)}.('nidm_clusterSizeInVoxels').('x_value'));
    
    searchSpaceMaskMap = searchforType('nidm_SearchSpaceMaskMap', graph);
    
    %Expected voxels per cluster (k)
    
    ftrTemp{3, 1} = 'Expected voxels per cluster, <k> = %0.3f';
    ftrTemp{3, 2} = str2num(searchSpaceMaskMap{1}.('nidm_expectedNumberOfVoxelsPerCluster').('x_value'));
    
    %Expected number of clusters (c)
    
    ftrTemp{4, 1} = 'Expected number of clusters, <c> = %0.2f';
    ftrTemp{4, 2} = str2num(searchSpaceMaskMap{1}.('nidm_expectedNumberOfClusters').('x_value'));
    
    % FWEp, FDRp, FWEc, FDRc
    
    FWEp = str2num(searchSpaceMaskMap{1}.('nidm_heightCriticalThresholdFWE05').('x_value'));
    FDRp = str2num(searchSpaceMaskMap{1}.('nidm_heightCriticalThresholdFDR05').('x_value'));
    FWEc = str2num(searchSpaceMaskMap{1}.('spm_smallestSignificantClusterSizeInVoxelsFWE05').('x_value'));
    FDRc = str2num(searchSpaceMaskMap{1}.('spm_smallestSignificantClusterSizeInVoxelsFDR05').('x_value'));
    
    ftrTemp{5,1} = 'FWEp: %0.3f, FDRp: %0.3f, FWEc: %0.0f, FDRc: %0.0f';
    ftrTemp{5,2} = [FWEp, FDRp, FWEc, FDRc];
    
    %Degrees of freedom
    statisticMap = searchforType('nidm_StatisticMap', graph);
    ftrTemp{6,1} = 'Degrees of freedom = [%0.1f, %0.1f]';
    for i = 1:length(statisticMap)
        if isfield(statisticMap{i}, 'nidm_effectDegreesOfFreedom')
            effectDegrees = statisticMap{i}.('nidm_effectDegreesOfFreedom').('x_value');
            errorDegrees = statisticMap{i}.('nidm_errorDegreesOfFreedom').('x_value');
            ftrTemp{6,2} = [str2num(effectDegrees),  str2num(errorDegrees)];
        end
    end 
    
    %FWHM
    
    fwhmID = searchforID(searchSpaceMaskMap{1}.nidm_inCoordinateSpace.('x_id'), graph);
    FWHMUnits = strrep(strrep(strrep(strrep(fwhmID.('nidm_voxelUnits'), '\"', ''), '[', ''), ']', ''), ',', '');
    
    ftrTemp{7, 1} = ['FWHM = %3.1f %3.1f %3.1f ', FWHMUnits '; %3.1f %3.1f %3.1f {voxels}'];
    
    unitsFWHM = str2num(searchSpaceMaskMap{1}.('nidm_noiseFWHMInUnits'));
    voxelsFWHM = str2num(searchSpaceMaskMap{1}.('nidm_noiseFWHMInVoxels'));
    
    ftrTemp{7,2} = [unitsFWHM, voxelsFWHM];
    
    %Volume
    
    volumeUnits = str2num(searchSpaceMaskMap{1}.('nidm_searchVolumeInUnits').('x_value'));
    volumeResels = str2num(searchSpaceMaskMap{1}.('nidm_searchVolumeInResels').('x_value'));
    volumeVoxels = str2num(searchSpaceMaskMap{1}.('nidm_searchVolumeInVoxels').('x_value'));
    
    ftrTemp{8, 1} = 'Volume: %0.0f = %0.0f voxels = %0.1f resels';
    ftrTemp{8, 2} = [volumeUnits, volumeVoxels, volumeResels];
    
    %Voxel dimensions and resel size
    
    temp = searchforID(searchSpaceMaskMap{1}.('nidm_inCoordinateSpace').('x_id'), graph);
    voxelSize = str2num(temp.('nidm_voxelSize'));
    voxelUnits = strrep(strrep(strrep(strrep(temp.('nidm_voxelUnits'), '\"', ''), '[', ''), ']', ''), ',', '');
    reselSize = str2num(searchSpaceMaskMap{1}.('nidm_reselSizeInVoxels').('x_value'));
    
    ftrTemp{9, 1} = ['Voxel size: %3.1f %3.1f %3.1f ', voxelUnits, '; (resel = %0.2f voxels)'];
    ftrTemp{9, 2} = [voxelSize reselSize];
    
    %===========================================
    %str field
    
    peakDefCriteria = searchforType('nidm_PeakDefinitionCriteria', graph);
    units = strtok(voxelUnits, ' ');
    strTemp = ['table shows 3 local maxima more than ', peakDefCriteria{1}.nidm_minDistanceBetweenPeaks.('x_value'), units, ' apart'];
    
    %===========================================
    %fmt
    
    fmtTemp = {'%-0.3f' '%g' '%0.3f' '%0.3f' '%0.0f' '%0.3f' '%0.3f' '%0.3f' '%6.2f' '%5.2f' '%0.3f' '%3.0f %3.0f %3.0f '};
    
    %=============================================
    
    NTabDat.tit = titleTemp;
    NTabDat.dat = tableTemp;
    NTabDat.ftr = ftrTemp;
    NTabDat.str = strTemp;
    NTabDat.fmt = fmtTemp;
end