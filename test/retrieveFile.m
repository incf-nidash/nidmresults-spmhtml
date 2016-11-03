function retrieveHTMLFile(filepath, filename)
    
    if nargin == 1
        if exist(fullfile(filepath, 'index.html'), 'file') == 2
            delete(fullfile(filepath, 'index.html'))
        end
        if exist(fullfile(filepath, 'indexTemp.html'), 'file') == 2
            movefile(fullfile(filepath, 'indexTemp.html'), fullfile(filepath, 'index.html'), 'f')
        end
    end
    
    if nargin == 2
        if exist(fullfile(filepath, filename), 'file') == 2
            delete(fullfile(filepath, filename))
        end
        [~, name, ext] = fileparts(filename);
        filenameTemp = [name, 'Temp', ext];
        if exist(fullfile(filepath, filenameTemp), 'file') == 2
            movefile(fullfile(filepath, filenameTemp), fullfile(filepath, filename), 'f')
        end
    end
    
end
