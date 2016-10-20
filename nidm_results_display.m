function nidm_results_display(jsonfilepath, overWrite)
    
    %Checks on input
    narginchk(1, 2);
    if nargin > 1
        validateattributes(overWrite,{'logical'}, {'scalar'});
    end
    %Ask user whether to overwrite files
    if nargin < 2 
        if exist(fullfile(fileparts(mfilename('fullpath')), 'Data', 'html'), 'dir') == 7
            button = questdlg('There currently exists a folder named HTML in the output directory. Proceeding will result in all files within the HTML folder being overwritten. Would you like to proceed?', 'Warning', 'Overwrite', 'Do not overwrite', 'Do not overwrite');
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

        spm_results_export(changeNIDMtoSPM(jsondoc),changeNIDMtoxSPM(jsondoc),changeNIDMtoTabDat(jsondoc));
    end
    
end