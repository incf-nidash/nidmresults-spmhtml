function base64string = getBase64(imagePath)

    %Generates Base64 encoding for image.
    fid = fopen(imagePath,'rb');
    bytes = fread(fid);
    fclose(fid);
    encoder = org.apache.commons.codec.binary.Base64;
    base64string = char(encoder.encode(bytes))';

end