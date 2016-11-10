%This function deletes the current file under 'filename' and checks to see
%if there is a file 'filenameTemp' stored. If there is, then 'filenameTemp'
%is renamed to 'filename'. This can be used in the teardown procedures for
%the tests.

function retrieveHTMLFile(filepath, filename)
    
    if exist(fullfile(filepath, filename), 'file') == 2
        delete(fullfile(filepath, filename))
    end
    [~, name, ext] = fileparts(filename);
    filenameTemp = [name, 'Temp', ext];
    if exist(fullfile(filepath, filenameTemp), 'file') == 2
        movefile(fullfile(filepath, filenameTemp), fullfile(filepath, filename), 'f');
    end
    
end
