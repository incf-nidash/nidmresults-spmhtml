%==========================================================================
%This function generates a base 64 encoding of an image. As an input it
%takes in:
%
%imagePath - the path to the image to be converted.
%
%Authors: Thomas Maullin, Camille Maumet.
%==========================================================================

function base64string = getBase64(imagePath)

    %Read the image in.
    fid = fopen(imagePath,'rb');
    bytes = fread(fid);
    fclose(fid);
    
    %Encode the image and return the string.
    encoder = org.apache.commons.codec.binary.Base64;
    base64string = char(encoder.encode(bytes))';

end