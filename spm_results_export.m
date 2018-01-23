function webID = spm_results_export(SPM,xSPM,TabDat,exNo, fHTML)
% Export SPM results in HTML
% FORMAT spm_results_export(SPM,xSPM,TabDat)
%__________________________________________________________________________
% Copyright (C) 2013 Wellcome Trust Centre for Neuroimaging

% Guillaume Flandin
% $Id: spm_results_export.m 5615 2013-08-15 14:37:24Z spm $
%
%==========================================================================
%Inputs:
%
% - SPM - an SPM created 'SPM' structure.
% - xSPM - an SPM created 'xSPM' structure.
% - TabDat - an SPM created 'TabDat' structure (optional if not using NIDM 
%            results data.
% - exNo - The index of the current excursion set if this is NIDM-Results
%          data with more than one excursion set. This is -1 if there is 
%          only one excursion set present and this is NIDM-Results data. 
%          Non-existant if SPM data.
% - fHTML - An output directory if this is an NIDM-Results display.
if nargin < 2
    error('Not enough input arguments.');
end
if nargin < 3
    TabDat = spm_list('Table',xSPM);
end
%If we are using NIDM-Results there will be a variable named exNo
%indicating how many excursion sets we have already displayed.
if exist('exNo', 'var')
    if exNo == -1
        multipleExcursions = false;
    end
    if exNo ~= -1
        multipleExcursions = true;
    end
%Otherwise we are looking at SPM input and there is only on excursion set
%to consider.
else
    multipleExcursions = false;
end
if nargin > 5
    error('Too many input arguments.');
end

%If spm_results export has been called on standard SPM, xSPM and TabDat 
%variables, output into the current directory, else if we are using 
%nidm-created SPM, xSPM and TabDat variables, output next to the NIDM json.

if ~isfield(SPM, 'nidm')
    software = 'SPM';
    nidmVersion = '';
    %If we are using NIDM-Results there will be a variable named fHTML for
    %the output directory.
    if exist('fHTML', 'var')
        %If no output directory is specified, specify one.
        if strcmp(fHTML, '')
            fHTML = pwd;
        end
    else
        fHTML = pwd;
    end
else
    software = TabDat.nidm.software;
    nidmVersion = ['Display of NIDM-Results pack generated using ' software ' ' TabDat.nidm.version];
    %If we are using NIDM-Results there will be a variable named fHTML for
    %the output directory.
    if exist('fHTML', 'var')
        %If no output directory is specified, specify one.
        if strcmp(fHTML, '')
            fHTML = SPM.nidm.filepath;
        end 
    else 
        fHTML = SPM.nidm.filepath;
    end
end

%Final file directory.
outdir  = spm_file(fullfile(fHTML,'temp'));
 
if exist('outdir', 'dir') ~= 7
    outdir = spm_file(outdir, 'uniquedir');
end

if(multipleExcursions)
    fHTML   = spm_file(fullfile(fHTML, ['index', num2str(exNo), '.html']));
else
    fHTML   = spm_file(fullfile(fHTML, 'index.html'));
end

%If fHTML already exists, ask if it should be overWritten.

if exist(fHTML, 'file') == 2
    if(multipleExcursions)
        button = questdlg(['The output file, index', num2str(exNo), '.html, already exists. Would you like this file to be overwritten?'], 'Warning', 'Overwrite', 'Do not overwrite', 'Do not overwrite');      
    else
        button = questdlg(['The output file, index.html, already exists. Would you like this file to be overwritten?'], 'Warning', 'Overwrite', 'Do not overwrite', 'Do not overwrite');      
    end
    switch button
        case 'Overwrite'
            overWrite = true;
        case 'Do not overwrite'
            overWrite = false;
        case ''
            overWrite = false;
    end
    if(~overWrite)
        webID = '0';
        return
    end
end

mkdir(outdir);

%If we're using matlab SPM, xSPM and TabDat objects we need to generate the 
%MIP and design matrix manually.

if ~isfield(xSPM, 'nidm')
    MIP     = spm_mip(xSPM.Z,xSPM.XYZmm,xSPM.M,xSPM.units);
end
if ~isfield(SPM, 'nidm') || strcmp(software, 'FSL')
    DesMtx  = (SPM.xX.nKX + 1)*32;
end

%-Create images for embedding, if they don't already exist.
%--------------------------------------------------------------------------
if ~isfield(xSPM, 'nidm')
    mipPath = spm_file(fullfile(outdir,'MIP.png'));
    imwrite(MIP,gray(64),mipPath,'png');
else
    mipPath = xSPM.nidm.MIP;
end

if ~isfield(SPM, 'nidm') || strcmp(software, 'FSL')
    ml = floor(size(DesMtx,1)/size(DesMtx,2));
    DesMtx = reshape(repmat(DesMtx,ml,1),size(DesMtx,1),[]);
    desMatPath = spm_file(fullfile(outdir,'DesMtx.png'));
    imwrite(DesMtx,gray(64),desMatPath,'png');
else
    ml = floor(SPM.nidm.dim(1)/SPM.nidm.dim(2));
    desMatPath = SPM.nidm.DesMat;
end

contrastPath = spm_file(fullfile(outdir,'contrast.png'));
con = [SPM.xCon(xSPM.Ic).c]';
con = (con/max(abs(con(:)))+1)*32;
con = kron(con,ones(ml,10));
imwrite(con,gray(64),contrastPath,'png');

%Check if the coordinates of the first peak are in the table. If not there
%are no peaks and we should set the cursor to be blank. Otherwise it is an
%arrow.
if(~isnan(TabDat.dat{1,12}))
    cursorString = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAALCAIAAADN+VtyAAAABnRSTlMAAAAAAABupgeRAAAAB3RJTUUH4AoLERQaiQnJ6gAAADFJREFUGJVjYMAG/jMwMGIKQQAjLlFGXAoZ/yPpQNbOgsVE/Dpw20HAVZhy2MF/BgYAbK0KCmhBjJQAAAAASUVORK5CYII=';
else
    cursorString = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAALCAIAAADN+VtyAAAABnRSTlMAAAAAAABupgeRAAAAB3RJTUUH4AsSDCYaYPacHQAAAA1JREFUGJVjYBgFaAAAARMAAXYknF0AAAAASUVORK5CYII=';
end

%-Save results as HTML file
%==========================================================================
tpl = spm_file_template(fileparts(mfilename('fullpath')));
tpl = tpl.file('TPL_RES','spm_results.tpl');
tpl = tpl.block('TPL_RES','resftr','resftrs');
tpl = tpl.block('TPL_RES','cursor','cursors');
tpl = tpl.block('TPL_RES','resrow','resrows');
tpl = tpl.var('DATE',[datestr(now,8) ' ' datestr(now,1) ' ' datestr(now,13)]);
tpl = tpl.var('SPM',spm('Version'));
tpl = tpl.var('CON_TITLE',xSPM.title);
tpl = tpl.var('RES_TITLE',TabDat.tit);
tpl = tpl.var('IMG_MIP',getEmbeddingString(mipPath));
tpl = tpl.var('IMG_CURSOR',cursorString);
tpl = tpl.var('IMG_CON',getEmbeddingString(contrastPath));
tpl = tpl.var('IMG_X',getEmbeddingString(desMatPath));
tpl = tpl.var('cursors','');
XYZmm = [0 0 0];
XYZ = spm_XYZreg('RoundCoords',XYZmm,xSPM.M,xSPM.DIM);
%-Copied from spm_mip_ui.m
DXYZ = [182 218 182];
CXYZ = [091 127 073];
%-Coordinates of Talairach origin in MIP image
% Transverse: [Po(1), Po(2)]
% Saggital  : [Po(1), Po(3)]
% Coronal   : [Po(4), Po(3)]
% 4 voxel offsets in Y since using image '<' as a pointer.
Po(1)  =                  CXYZ(2) -2;
Po(2)  = DXYZ(3)+DXYZ(1) -CXYZ(1) -4;
Po(3)  = DXYZ(3)         -CXYZ(3) -4;
Po(4)  = DXYZ(2)         +CXYZ(1) -2;
x(1)=Po(1)+XYZ(2); y(1)=Po(2)+XYZ(1);
x(2)=Po(1)+XYZ(2); y(2)=Po(3)-XYZ(3);
x(3)=Po(4)+XYZ(1); y(3)=Po(3)-XYZ(3);
for i=1:3
    tpl = tpl.var('CS_ID',sprintf('cs%d',i));
    tpl = tpl.var('CS_X',sprintf('%d',x(i)));
    tpl = tpl.var('CS_Y',sprintf('%d',y(i)));
    tpl = tpl.parse('cursors','cursor',1);
end
tpl = tpl.var('RES_STR',TabDat.str);
tpl = tpl.var('SOFTWARE',software);
tpl = tpl.var('NIDMVERSION', nidmVersion);
tpl = tpl.var('STAT_STR',strrep(strrep(xSPM.STATstr,'_{','<sub>'),'}','</sub>'));
tpl = tpl.var('CON_STAT',xSPM.STAT);
tpl = tpl.var('resrows','');
for i=1:size(TabDat.dat,1)
    tpl = tpl.var('RES_COL1','1');
    for j=1:size(TabDat.dat,2)-1
        tpl = tpl.var(sprintf('RES_COL%d',j),sprintf(TabDat.fmt{j},TabDat.dat{i,j}));
    end
    tpl = tpl.var('RES_COL12',strrep(sprintf(TabDat.fmt{end},TabDat.dat{i,end}),' ','&nbsp;'));
    tpl = tpl.var('RES_XYZ',sprintf('%d,%d,%d',TabDat.dat{i,end}));
    tpl = tpl.parse('resrows','resrow',1);
end
tpl = tpl.var('resftrs','');

%Information is split into two columns for presentation purposes.
half_footer_size = floor((size(TabDat.ftr,1))/2);
for i=1:half_footer_size
    tpl = tpl.var('RES_FTR_1', sprintf(TabDat.ftr{i,1},TabDat.ftr{i,2}));
    tpl = tpl.var('RES_FTR_2', sprintf(TabDat.ftr{i+half_footer_size,1},TabDat.ftr{i+half_footer_size,2}));
    tpl = tpl.parse('resftrs','resftr',1);
end
if (size(TabDat.ftr,1) > 2*half_footer_size)
    tpl = tpl.var('RES_FTR_1', sprintf(TabDat.ftr{size(TabDat.ftr,1),1},TabDat.ftr{size(TabDat.ftr,1),2}));
    tpl = tpl.var('RES_FTR_2', '');
    tpl = tpl.parse('resftrs','resftr',1);
end

tpl = tpl.parse('OUT','TPL_RES');
fid = fopen(fHTML,'wt');
fprintf(fid,'%c',get(tpl,'OUT'));
fclose(fid);
%==========================================================================
%-Delete temporary files

rmdir(outdir, 's');

%-Display webpage
%==========================================================================
if(multipleExcursions && exNo >1)
    [~, webID] = web(fHTML, '-new');
else
    [~, webID] = web(fHTML);
end