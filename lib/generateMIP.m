%==========================================================================
%This function generates an MIP image from the nii.gz format. It takes as
%inputs:
%
%filepath - The location of the nii.gz file.
%filename - The name of the nii.gz file.
%DIM - The dimensions in voxels.
%units - The units the MIP is written in.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function generateMIP(filepath, filename, DIM, units)
    
    %Unzip the nii.gz
    gunzip(fullfile(filepath, filename));
    
    %As FSL uses zeros to represent no activation, whereas SPM uses NaNs,
    %covert all zero's to NaNs.
    excset_img = nifti(strrep(fullfile(filepath, filename), '.gz', ''));
    excset_img.dat(find(excset_img.dat(:)==0)) = NaN;
    
    %Create the excursionSet accounting for NaNs.
    V=spm_vol(strrep(fullfile(filepath, filename), '.gz', ''));
    M=V.mat;
    [T,XYZ]=spm_read_vols(V,1);
    I = ~isnan(T);
    Tth=T(I);
    XYZth=XYZ(:,I);
    
    %Convert the units to the required format.
    remain = units;
    units = {};
    for i = 1:3
        [token, remain] = strtok(remain, ' ');
        units{i} = token;
    end
    
    %Get Ms and Md.
    [Ms, Md] = getMsMd(units, M, DIM);
    
    %Account for the units.
    pXYZ = Ms*Md*[XYZth;ones(1,size(XYZth,2))];
    mip = spm_mip(Tth,pXYZ(1:3,:),Ms*Md*M,units);
    
    %Write the image:
    mipPath = spm_file(fullfile(filepath, 'MIP.png'));
    imwrite(mip,gray(64),mipPath,'png');

    %In some versions of octave/matlab the above removes
    %the original .nii.gz file.
    if ~exist(fullfile(filepath, filename), 'file')
        gzip(strrep(fullfile(filepath, filename), '.gz', ''));
    end
    
end