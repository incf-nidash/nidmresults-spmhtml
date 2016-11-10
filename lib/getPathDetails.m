%This function checks if a path stored in an NIDM-Results pack is empty,
%relative or a webURL and returns the answer as type. It then creates
%a resultantPath which gives where the file is located locally. 

function [resultantPath, type] = getPathDetails(fullpath, nidmLocation)

    [path, filename, ext] = fileparts(fullpath);
    if isempty(path)
        type = 'empty';
    elseif strcmp(path(1), '.')
        type = 'relative';
    else
        type = 'webURL';
    end
    
    if strcmp(type, 'empty') || strcmp(type, 'relative')
        resultantPath = fullfile(nidmLocation, fullpath);
    else
        if ~(exist(fullfile(nidmLocation, [filename, ext]), 'file') == 2)
            websave(fullfile(nidmLocation, [filename, ext]), fullpath);
        end
        resultantPath = fullfile(nidmLocation, [filename, ext]);
    end
    
end