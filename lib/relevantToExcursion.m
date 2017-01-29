%==========================================================================
%This function takes in a list of objects and returns only those connected
%to the specified excursionSet. It takes in 3 inputs.
%
%inputCell - a cell of input objects.
%exNo - the number corresponding to the excursion set of interest.
%labels - the corresponding label hashmap.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================
function resultant = relevantToExcursion(inputCell, exNo, labels)
    
    counter = 1;
    resultant = {};
    %Work out which object belongs to which excursion set.
    for(i = 1:length(inputCell))
        if(any(ismember(labels(inputCell{i}.x_id),exNo)))
            resultant{counter} = inputCell{i};
            counter = counter+1;
        end
    end
    
end