function webID = nidm_results_display(jsonfilepath, overWrite)
    
    %Checks on input
    narginchk(1, 2);
    if nargin > 1
        validateattributes(overWrite,{'logical'}, {'scalar'});
    end
    %Ask user whether to overwrite files
    if nargin < 2 
        if exist(fullfile(fileparts(mfilename('fullpath')), 'Data', 'index.html'), 'file') == 2
            button = questdlg('The output file, index.html, already exists. Would you like this file to be overwritten?', 'Warning', 'Overwrite', 'Do not overwrite', 'Do not overwrite');
            switch button
                case 'Overwrite'
                    overWrite = true;
                case 'Do not overwrite'
                    overWrite = false;
                case ''
                    overWrite = false;
            end
        else
            overWrite = true;
        end
    end
    
    if(overWrite)
        %Record users choice and filepath.
        jsondoc=spm_jsonread(jsonfilepath);
        pathstr = fileparts(jsonfilepath); 
        jsondoc.filepath = pathstr;

        %Add path to required methods
        if exist('changeNIDMtoSPM') ~= 2
            addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'));
        end

        webID = spm_results_export(changeNIDMtoSPM(jsondoc),changeNIDMtoxSPM(jsondoc),changeNIDMtoTabDat(jsondoc));
    else
        webID = 0;
    end
    
end