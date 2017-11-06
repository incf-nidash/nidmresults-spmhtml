%==========================================================================
%This function deletes the current file under 'filename' and checks to see
%if there is a file 'filenameTemp' stored. If there is, then 'filenameTemp'
%is renamed to 'filename'. This can be used in the teardown procedures for
%the tests. It takes as inputs:
%
%filepath - the location of the file.
%filename - the name to be recovered.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function retrieveHTMLFile(filepath, filename)
    
    %If the file exists delete it.
    if exist(fullfile(filepath, filename), 'file') == 2
        delete(fullfile(filepath, filename))
    end
    
    %If the temp version exists move it back.
    [~, name, ext] = fileparts(filename);
    filenameTemp = [name, 'Temp', ext];
    if exist(fullfile(filepath, filenameTemp), 'file') == 2
        movefile(fullfile(filepath, filenameTemp), fullfile(filepath, filename), 'f');
    end
    
end
