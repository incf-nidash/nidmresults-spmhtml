function storeFile(filepath, filename)
    
    if nargin == 1
        if exist(fullfile(filepath, 'index.html')) == 2
             movefile(fullfile(filepath, 'index.html'), fullfile(filepath, 'indexTemp.html'));
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