%==========================================================================
%Generate an object with the same format as the SPM-output variable, TabDat, 
%using the information from an input NIDM-Results json pack. This takes in 
%one argument:
%
%json - the spm_jsonread form of the NIDM-Results json file.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function NTabDat = changeNIDMtoTabDat(json)
    
    graph = json.('x_graph');
    NTabDat = struct;
    
    %======================================================================
    %tit - the title of the results
    
    titleTemp = 'p-values adjusted for search volume';
    
    %======================================================================
    %nidm - Checking which software was used to generate the NIDM json.
    
    software = '';
    agentObjects = searchforType('prov:SoftwareAgent', graph);
    
    %Check all agent objects for one with the software version stored.
    for i = 1:length(agentObjects)
        if any(ismember(agentObjects{i}.('x_type'), 'http://scicrunch.org/resolver/SCR_002823'))...
                || any(ismember(agentObjects{i}.('x_type'), 'src_FSL'))
            software = 'FSL';
        end
        if any(ismember(agentObjects{i}.('x_type'), 'http://scicrunch.org/resolver/SCR_007037'))...
                || any(ismember(agentObjects{i}.('x_type'), 'src_SPM'))
            software = 'SPM';
        end
    end 
    
    nidmTemp = struct;
    nidmTemp.software = software;
    
    %======================================================================
    %ftr field
   
    ftrTemp = cell(1);
    
    %Height thresholds
    heightThresholds = searchforType('nidm_HeightThreshold', graph);
    
    %Retrieve the indices of the threshold array which in the following
    %order [FWE, FDR, unCorr, stat] (eg if looking for a threshold of FWE
    %type, look for it's index in the first postion of hPositions). If
    %the statistic type does not exist the position value will be zero.
    hPositions = getThresholdPositions(heightThresholds);
    
    threshList = [];
    
    %If there exists a statistic threshold record it.
    if hPositions(4) ~= 0
        strStat = 'Height threshold: T = %0.2f, ';
        height_1 = str2double(heightThresholds{hPositions(4)}.('prov_value').('x_value'));
        threshList = [threshList, height_1];
    else
        strStat = '';
    end
    
    %If there exists a unCorrected P-Value threshold record it.
    if hPositions(3) ~= 0
        strPuncorr = 'p = %0.3f';
        height_2 = str2double(heightThresholds{hPositions(3)}.('prov_value').('x_value'));
        threshList = [threshList, height_2];
    else
        strPuncorr = '';
    end
    
    %If there exists a FWE threshold record it.
    if hPositions(2) ~= 0
        height_3 = str2double(heightThresholds{hPositions(2)}.('prov_value').('x_value')); 
        strFWEFDR = '(%0.3f FDR)';
        threshList = [threshList, height_3];
    %Else, if there exists a FDR threshold record it.
    elseif hPositions(1) ~= 0
        height_4 = str2double(heightThresholds{hPositions(1)}.('prov_value').('x_value'));
        strFWEFDR = '(%0.3f FWE)';
        threshList = [threshList, height_4];
    else
        strFWEFDR = '';
    end

    ftrTemp{1, 1} = strcat(strStat, strPuncorr, strFWEFDR);
    ftrTemp{1, 2} = threshList;
    
    %Extent Threshold
    
    extentThresholds = searchforType('nidm_ExtentThreshold', graph);
    ePositions = getThresholdPositions(extentThresholds);
    
    %Make the string for displaying extent thresholds and store the extent
    %thresholds themselves.
    if ePositions(4) ~= 0
        ftrTemp{2, 1} = 'Extent threshold: k = %0.0f voxels';  
        ftrTemp{2, 2} = str2double(extentThresholds{ePositions(4)}.('nidm_clusterSizeInVoxels').('x_value'));
    elseif ePositions(1) ~= 0
        ftrTemp{2, 1} = 'Extent threshold: p < %0.0f (FWE)';  
        ftrTemp{2, 2} = str2double(extentThresholds{ePositions(1)}.('prov_value').('x_value'));
    elseif ePositions(2) ~= 0
        ftrTemp{2, 1} = 'Extent threshold: p < %0.0f (FDR)';  
        ftrTemp{2, 2} = str2double(extentThresholds{ePositions(2)}.('prov_value').('x_value'));
    elseif ePositions(3) ~= 0
        ftrTemp{2, 1} = 'Extent threshold: p < %0.0f (Uncorrected)';  
        ftrTemp{2, 2} = str2double(extentThresholds{ePositions(3)}.('prov_value').('x_value'));
    else
        ftrTemp{2, 1} = '';  
        ftrTemp{2, 2} = NaN;
    end
    
    searchSpaceMaskMap = searchforType('nidm_SearchSpaceMaskMap', graph);
    
    %Find the searchSpaceMaskMap object linked to the coordinate space.
    searchLinkedToCoord = '';
    for i=1:length(searchSpaceMaskMap)
        if isfield(searchSpaceMaskMap{i}, 'nidm_inCoordinateSpace')
            searchLinkedToCoord = searchSpaceMaskMap{i};
        end
    end
    
    if ~strcmp(software, 'FSL') 
        
        %Expected voxels per cluster (k)
        ftrTemp{3, 1} = 'Expected voxels per cluster <k> = %0.3f';
        ftrTemp{3, 2} = str2double(searchLinkedToCoord.('nidm_expectedNumberOfVoxelsPerCluster').('x_value'));
    
        %Expected number of clusters (c)
        ftrTemp{4, 1} = 'Expected number of clusters <c> = %0.2f';
        ftrTemp{4, 2} = str2double(searchLinkedToCoord.('nidm_expectedNumberOfClusters').('x_value'));
    
        %FWEp, FDRp
        FWEp = str2double(searchLinkedToCoord.('nidm_heightCriticalThresholdFWE05').('x_value'));
        FDRp = str2double(searchLinkedToCoord.('nidm_heightCriticalThresholdFDR05').('x_value'));
        stringTemp = 'FWEp: %0.3f, FDRp: %0.3f';
        arrayTemp = [FWEp, FDRp];
        
        %If its there, include FWEc
        if(isfield(searchLinkedToCoord, 'spm_smallestSignificantClusterSizeInVoxelsFWE05'))
            FWEc = str2double(searchLinkedToCoord.('spm_smallestSignificantClusterSizeInVoxelsFWE05').('x_value'));
            stringTemp = [stringTemp, ', FWEc: %0.0f'];
            arrayTemp = [arrayTemp, FWEc];
        end
        
        %If its there, include FDRc
        if(isfield(searchLinkedToCoord, 'spm_smallestSignificantClusterSizeInVoxelsFDR05'))
            FDRc = str2double(searchLinkedToCoord.('spm_smallestSignificantClusterSizeInVoxelsFDR05').('x_value'));
            stringTemp = [stringTemp, ', FDRc: %0.0f'];
            arrayTemp = [arrayTemp, FDRc];
        end
    
        ftrTemp{5,1} = stringTemp;
        ftrTemp{5,2} = arrayTemp;
        rowCount = 5;
    else
        rowCount = 2;
    end
    
    %Index of degrees of freedom
    rowCount = rowCount+1;
    effectDegrees = 0;
    errorDegrees = 0;
    
    statisticMap = searchforType('nidm_StatisticMap', graph);
    ftrTemp{rowCount,1} = 'Degrees of freedom = [%0.1f, %0.1f]';
    
    %Find degrees of freedom in statisticMap objects.
    for i = 1:length(statisticMap)
        if isfield(statisticMap{i}, 'nidm_effectDegreesOfFreedom')
            effectDegrees = statisticMap{i}.('nidm_effectDegreesOfFreedom').('x_value');
            errorDegrees = statisticMap{i}.('nidm_errorDegreesOfFreedom').('x_value');
            ftrTemp{rowCount,2} = [str2double(effectDegrees),  str2double(errorDegrees)];
        end
    end 
    
    %FWHM
    
    rowCount = rowCount+1;
    
    %Retrieve the units of the coordinate space.
    searchSpace = searchforID(searchLinkedToCoord.nidm_inCoordinateSpace.('x_id'), graph);
    FWHMUnits = strrep(strrep(strrep(strrep(searchSpace.('nidm_voxelUnits'), '\"', ''), '[', ''), ']', ''), ',', '');
    
    ftrTemp{rowCount, 1} = ['FWHM = %3.1f %3.1f %3.1f ', FWHMUnits '; %3.1f %3.1f %3.1f {voxels}'];
    
    %Store the FWHM in units and voxels
    unitsFWHM = str2num(searchLinkedToCoord.('nidm_noiseFWHMInUnits'));
    voxelsFWHM = str2num(searchLinkedToCoord.('nidm_noiseFWHMInVoxels'));
    
    ftrTemp{rowCount,2} = [unitsFWHM, voxelsFWHM];
    
    %Volume
    
    rowCount = rowCount+1;
    volumeUnits = str2double(searchLinkedToCoord.('nidm_searchVolumeInUnits').('x_value'));
    volumeResels = str2double(searchLinkedToCoord.('nidm_searchVolumeInResels').('x_value'));
    volumeVoxels = str2double(searchLinkedToCoord.('nidm_searchVolumeInVoxels').('x_value'));
    
    ftrTemp{rowCount, 1} = 'Volume: %0.0f = %0.0f voxels = %0.1f resels';
    ftrTemp{rowCount, 2} = [volumeUnits, volumeVoxels, volumeResels];
    
    %Voxel dimensions and resel size
    
    rowCount = rowCount+1;
    voxelSize = str2num(searchSpace.('nidm_voxelSize'));
    voxelUnits = strrep(strrep(strrep(strrep(searchSpace.('nidm_voxelUnits'), '\"', ''), '[', ''), ']', ''), ',', '');
    reselSize = str2double(searchLinkedToCoord.('nidm_reselSizeInVoxels').('x_value'));
    
    ftrTemp{rowCount, 1} = ['Voxel size: %3.1f %3.1f %3.1f ', voxelUnits, '; (resel = %0.2f voxels)'];
    ftrTemp{rowCount, 2} = [voxelSize reselSize];
    
    %======================================================================
    %dat
    
    tableTemp = cell(1);
    
    %Set-level:
    
    %As there are no set level statistics in FSL, set these values to NaN
    %if the nidm pack was generated by FSL.
    if strcmp(software, 'FSL')
        tableTemp{1, 1} = NaN;
        tableTemp{1, 2} = NaN;
    end
    
    %In SPM however the set level statistics are found in the excursion set
    %map in the nidm json.
    if strcmp(software, 'SPM') 
        excursionSetMap = searchforType('nidm_ExcursionSetMap', graph);
        tableTemp{1, 1} = str2double(excursionSetMap{1}.('nidm_pValue').('x_value'));
        tableTemp{1, 2} = str2double(excursionSetMap{1}.('nidm_numberOfSupraThresholdClusters').('x_value'));
    end
    
    %Cluster and peak level:
    
    clusters = searchforType('nidm_SupraThresholdCluster', graph);
    peakDefCriteria = searchforType('nidm_PeakDefinitionCriteria', graph);
    
    if~isempty(clusters)
        
        %Sorting the clusters by descending size.
        oo=cellfun(@(x) x.('nidm_clusterSizeInVoxels').('x_value'), clusters, 'UniformOutput', false);
        aa=str2num(char(oo{:}));
        [~, idx]=sort(aa, 'descend');
        clusters = clusters(idx);

        %Create keySet and valueSet
        keySet = cellfun(@(x) x.('x_id'), clusters, 'UniformOutput', false);
        valueSet = NaN(1, length(keySet));

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
            clusSet=cellfun(@(x) x.('nidm_equivalentZStatistic').('x_value'), clustmaptemp, 'UniformOutput', false);
            orderedClusSet=str2num(char(clusSet{:}));
            [~, idx]=sort(orderedClusSet, 'descend');
            clusterPeakMap(clusterID) = clustmaptemp(idx);
        end
    
        %Read data from the cluster-peak hash-map created above.
        n = 1;
        
        %Check whether clusters have values stored.
        clustersFDRP = isfield(clusters{1}, 'nidm_qValueFDR');
        clustersPUncorr = isfield(clusters{1}, 'nidm_pValueUncorrected');
        
        %Check whether peaks have values stored.
        peaksFWEP = isfield(peaks{1}, 'nidm_pValueFWER');
        peaksFDRP = isfield(peaks{1}, 'nidm_qValueFDR');
        peaksStat = isfield(peaks{1}, 'prov_value');
        
        %Get statistic type and number of peaks to display
        statType = getStatType(graph);
        if isfield(peakDefCriteria{1}, 'nidm_maxNumberOfPeaksPerCluster')
            numOfPeaks = peakDefCriteria{1}.nidm_maxNumberOfPeaksPerCluster.('x_value');
        else
            numOfPeaks = 3;
        end 
        
        for i = 1:length(keySet)
            %Fill in the values we know.
            tableTemp{n, 3} = str2double(clusters{i}.('nidm_pValueFWER').('x_value'));
            if clustersFDRP
                tableTemp{n, 4} = str2double(clusters{i}.('nidm_qValueFDR').('x_value'));
            else
                tableTemp{n, 4} = NaN;
            end
            tableTemp{n, 5} = str2double(clusters{i}.('nidm_clusterSizeInVoxels').('x_value'));
            if clustersPUncorr
                tableTemp{n, 6} = str2double(clusters{i}.('nidm_pValueUncorrected').('x_value'));
            else
                tableTemp{n, 6} = NaN;
            end
            peaksTemp = clusterPeakMap(keySet{i});
        
            for j = 1:min(numOfPeaks, length(peaksTemp))
                %Fill the values we know.
                if peaksFWEP
                    tableTemp{n, 7} = str2double(peaksTemp{j}.('nidm_pValueFWER').('x_value'));
                end
                if peaksFDRP
                    tableTemp{n, 8} = str2double(peaksTemp{j}.('nidm_qValueFDR').('x_value'));
                end
                tableTemp{n, 11} = str2double(peaksTemp{j}.('nidm_pValueUncorrected').('x_value'));
                if peaksStat
                    tableTemp{n, 9} = str2double(peaksTemp{j}.('prov_value').('x_value'));
                else
                    %Calculate whichever statistic type is used.
                    if strcmp('statType', 'T')
                        tableTemp{n, 9} = icdf('T',1-tableTemp{n, 11},str2double(errorDegrees));
                    elseif strcmp('statType', 'X')
                        tableTemp{n, 9} = icdf('Chi',1-tableTemp{n, 11},str2double(errorDegrees));
                    elseif strcmp('statType', 'Z')
                        tableTemp{n, 9} = icdf('Normal',1-tableTemp{n, 11}, 0, 1);
                    elseif strcmp('statType', 'F')
                        tableTemp{n, 9} = icdf('F',1-tableTemp{n, 11}, str2double(effectDegrees), str2double(errorDegrees));
                    else
                        tableTemp{n, 9} = NaN;
                    end
                end 
                tableTemp{n, 10} = str2double(peaksTemp{j}.('nidm_equivalentZStatistic').('x_value'));
                locTemp = peaksTemp{j}.('prov_atLocation').('x_id');
                locTemp = searchforID(locTemp, graph);
                tableTemp{n, 12} = str2num(locTemp.nidm_coordinateVector);
                n = n+1;
             end
        end
        
        [height, ~] = size(tableTemp);
        
        %Otherwise fill the gaps with NaN.
        if ~peaksFWEP
            [tableTemp{1:height, 7}] = deal(NaN);
        end
        if ~peaksFDRP
            [tableTemp{1:height, 8}] = deal(NaN);
        end
        
    else
        %If no cluster values are available set the remaining values in the
        %first row of the table to NaN.
        for i = 3:13
            tableTemp{1, i} = NaN;
        end
    end
    
    %===========================================
    %str field
    
    if(~isempty(peakDefCriteria))
        units = strtok(voxelUnits, ' ');
        if isfield(peakDefCriteria{1}, 'nidm_maxNumberOfPeaksPerCluster')
            strTemp = ['table shows ', peakDefCriteria{1}.nidm_maxNumberOfPeaksPerCluster.('x_value'), ' local maxima more than ', peakDefCriteria{1}.nidm_minDistanceBetweenPeaks.('x_value'), units, ' apart'];
        else
            strTemp = ['table shows 3 local maxima more than ', peakDefCriteria{1}.nidm_minDistanceBetweenPeaks.('x_value'), units, ' apart'];
        end
    else 
        strTemp = '';
    end
    
    %======================================================================
    %fmt
    
    fmtTemp = {'%-0.3f' '%g' '%0.3f' '%0.3f' '%0.0f' '%0.3f' '%0.3f' '%0.3f' '%6.2f' '%5.2f' '%0.3f' '%3.0f %3.0f %3.0f '};
    
    %======================================================================
    
    NTabDat.tit = titleTemp;
    NTabDat.dat = tableTemp;
    NTabDat.ftr = ftrTemp;
    NTabDat.str = strTemp;
    NTabDat.fmt = fmtTemp;
    NTabDat.nidm = nidmTemp;
end