function generateMIP(filepath, graph)
    
    %Find the excursionSetMap nii.
    excursionSetMaps = searchforType('nidm_ExcursionSetMap', graph);
    excursionSet = excursionSetMaps{1};
    filename = excursionSet.('nfo_fileName');
    
    %Find DIM.
    coordSpaceId = excursionSet.('nidm_inCoordinateSpace').('x_id');
    coordSpace = searchforID(coordSpaceId, graph);
    DIM = str2num(coordSpace.('nidm_dimensionsInVoxels'))';
    
    %Unzip the nii.gz
    gunzip(fullfile(filepath, filename));
    
    %Create the excursionSet accounting for NaNs.
    V=spm_vol('ExcursionSet.nii');
    M=V.mat;
    [T,XYZ]=spm_read_vols(V,1);
    I = ~isnan(T);
    Tth=T(I);
    XYZth=XYZ(:,I);
    units={'mm','mm','mm'};
    
    %Get Ms and Md.
    [Ms, Md] = getMsMd(units, M, DIM);
    
    %Account for the units.
    pXYZ = Ms*Md*[XYZth;ones(1,size(XYZth,2))];
    mip = spm_mip(Tth,pXYZ(1:3,:),Ms*Md*M,units);
    
    %Testing:
    image(mip)
    colormap gray; axis image; axis off

end