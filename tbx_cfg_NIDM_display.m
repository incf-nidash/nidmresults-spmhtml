%==========================================================================
% This is the config function for the NIDM-Results display toolbox.
%
% Author: Tom Maullin (06/11/2017)
%==========================================================================

function nidmdisplay = tbx_cfg_NIDM_display()
    
    %Add the path to the toolbox directory.
    toolboxDir = spm_file(mfilename('fullpath'), 'fpath');
    if ~isdeployed
        addpath(toolboxDir);
        addpath(fullfile(toolboxDir, 'test'));
    end
    
    %Excursion sets specified numerically.
    exSet_num          = cfg_entry;
    exSet_num.name     = 'Excursion Set Numbers';
    exSet_num.help    = {'',...
       'Specify numerically which excursion sets you wish to view.',... 
       'If unsure of the numerical values corresponding to excursion sets, choose "Select".'};
    exSet_num.strtype = 'e';
    exSet_num.tag      = 'exNums';
    exSet_num.num     = [Inf 1];
    
    %Display all excursion sets.
    exSet_all      = cfg_const;
    exSet_all.tag  = 'allEx';
    exSet_all.name = 'All';
    exSet_all.val  = {0};
    exSet_all.help = {'This will display all excursion sets in the NIDM-Pack.'};
    
    %Display all excursion sets.
    exSet_select      = cfg_const;
    exSet_select.tag  = 'selectEx';
    exSet_select.name = 'Select';
    exSet_select.val  = {0};
    exSet_select.help = {'This will open the contrast selection window when the batch job is run.'};
    
    %Excursion set display options.
    exSet         = cfg_choice;
    exSet.name    = 'Excursion sets to display';
    exSet.tag     = 'exSet';
    exSet.values  = {exSet_num, exSet_all, exSet_select};
    
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
    nidmdisplay.val     = {nidmpack outputDirCfg exSet} ;
    nidmdisplay.tag     = 'NIDMdisplay';
    nidmdisplay.name    = 'NIDM-Results Display';
    nidmdisplay.help    = {'NIDM-Results Display.'}';
    nidmdisplay.prog    = @tbx_run_NIDM_display;

end
