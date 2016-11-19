%==========================================================================
%This function returns a string for embedding an image in a HTML file. It
%takes in one input:
%
%imagePath - the path to the image to be converted.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function embedString = getEmbeddingString(imagePath)

    %Returns string for embedding image HTML
    embedString = strcat('data:image/png;base64,', getBase64(imagePath));
    
end