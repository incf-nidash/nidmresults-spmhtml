%Tom N's original way

gunzip('TStatistic.nii.gz')
u=3.01
V=spm_vol('TStatistic.nii');
M=V.mat;
[T,XYZ]=spm_read_vols(V,1);
I=T>=u;
Tth=T(I);
XYZth=XYZ(:,I);
units={'mm','mm','mm'};
mip=spm_mip(Tth,XYZth,M,units);

image(mip)
colormap gray; axis image; axis off

%Way to do with excursion set map
gunzip('ExcursionSet.nii.gz');
V=spm_vol('ExcursionSet.nii');
M=V.mat;
[T,XYZ]=spm_read_vols(V,1);
Tth=T(~isnan(T));
XYZth=XYZ(:,I);
units={'mm','mm','mm'};
mip=spm_mip(Tth,XYZth,M,units);
image(mip)
colormap gray; axis image; axis off
