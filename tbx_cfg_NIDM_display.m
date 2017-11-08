%==========================================================================
% This is the config function for the NIDM-Results display toolbox.
%
% Author: Tom Maullin (06/11/2017)
%==========================================================================

function nidmdisplay = tbx_cfg_NIDM_display()
    
    %Add the path to the toolbox directory.
    toolboxDir = spm_str_manip(mfilename('fullpath'), 'h');
    addpath(toolboxDir);
    addpath(fullfile(toolboxDir, 'test'));
    
    %Output Directory.
    outputDirCfg         = cfg_files; 
    outputDirCfg.name    = 'Output Directory'; 
    outputDirCfg.tag     = 'dir';       
    outputDirCfg.filter  = 'dir';
    outputDirCfg.ufilter = '.*';
    outputDirCfg.num     = [1 1];     
    outputDirCfg.help    = {'','This sets the NIDM-Results output directory.','All displays will appear in this directory.'}; 
  
    %Specify NIDM pack.
    nidmpack         = cfg_files;
    nidmpack.tag     = 'nidmpack';
    nidmpack.name    = 'NIDM-Results pack';
    nidmpack.help    = {'Specify an NIDM-Results pack to display.'};
    nidmpack.ufilter = '.nidm.zip';
    nidmpack.num     = [0 1];

    %NIDM-Display 
    nidmdisplay         = cfg_exbranch;
    nidmdisplay.val     = {nidmpack outputDirCfg} ;
    nidmdisplay.tag     = 'NIDMdisplay';
    nidmdisplay.name    = 'NIDM-Results Display';
    nidmdisplay.help    = {'NIDM-Results Display.'}';
    nidmdisplay.prog    = @tbx_run_NIDM_display;

end