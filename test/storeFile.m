%This function moves the file 'filename' to a temporary location
%'filenameTemp' to prevent the tests overwriting any of the users data. If
%only one argument is provided it is assumed the file in question is named
%'index.html'.

function storeFile(filepath, filename)
    
    if nargin == 1
        if exist(fullfile(filepath, 'index.html')) == 2
             movefile(fullfile(filepath, 'index.html'), spm_file(fullfile(filepath, 'indexTemp.html'), 'unique'));
        end
    end
    
    if nargin == 2
        if exist(fullfile(filepath, filename)) == 2
            [~, name, ext] = fileparts(filename);
            filenameTemp = [name, 'Temp', ext];
            movefile(fullfile(filepath, filename), fullfile(filepath, filenameTemp));
        end
    end
    
end