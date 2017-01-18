%==========================================================================
%This function moves the file 'filename' to a temporary location
%'filenameTemp' to prevent the tests overwriting any of the users data. If
%only one argument is provided it is assumed the file in question is named
%'index.html'. It takes the following inputs:
%
%filepath - the location of the file.
%filename - the name to be changed. If not entered it is assumed we are
%looking for the 'index.html' file.
%
%Authors: Thomas Maullin, Camille Maumet
%==========================================================================

function storeFile(filepath, filename)
    
    %If there's one input move 'index.html'.
    if nargin == 1
        if exist(fullfile(filepath, 'index.html')) == 2
             movefile(fullfile(filepath, 'index.html'), spm_file(fullfile(filepath, 'indexTemp.html'), 'unique'));
        end
    end
    
    %If there's two inputs move filename.
    if nargin == 2
        if exist(fullfile(filepath, filename)) == 2
            [~, name, ext] = fileparts(filename);
            filenameTemp = [name, 'Temp', ext];
            movefile(fullfile(filepath, filename), fullfile(filepath, filenameTemp));
        end
    end
    
end