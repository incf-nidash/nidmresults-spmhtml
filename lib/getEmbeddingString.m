function embedString = getEmbeddingString(imagePath)

    %Returns string for embedding image HTML
    embedString = strcat('data:image/png;base64,', getBase64(imagePath));
    
end