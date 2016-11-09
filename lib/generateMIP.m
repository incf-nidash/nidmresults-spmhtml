function generateMIP(filepath, filename, DIM, units)
    
    %Unzip the nii.gz
    gunzip(fullfile(filepath, filename));
    
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
    units={'mm','mm','mm'};
    
    %Get Ms and Md.
    [Ms, Md] = getMsMd(units, M, DIM);
    
    %Account for the units.
    pXYZ = Ms*Md*[XYZth;ones(1,size(XYZth,2))];
    mip = spm_mip(Tth,pXYZ(1:3,:),Ms*Md*M,units);
    
    %Write the image:
    mipPath = spm_file(fullfile(filepath, 'MIP.png'));
    imwrite(mip,gray(64),mipPath,'png');
    
end