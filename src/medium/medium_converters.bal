function convertToUser(json response) returns User {
    User user = {
        id: <string>response.data.id,
        username: <string>response.data.username,
        name: <string>response.data.name,
        url: <string>response.data.url,
        imageUrl: <string>response.data.imageUrl        
    };
    return user;
}

function convertToPostResponse(json response) returns PostResponse {
    PostResponse postresponse = {
        id:<string>response.data.id,
        title:<string>response.data.title,
        authorId:<string>response.data.authorId,
        tags:<json[]>response.data.tags,
        url:<string>response.data.url,
        canonicalUrl:<string>response.data.canonicalUrl,
        publishStatus:<string>response.data.publishStatus,
        publishedAt:<int|error>response.data.publishedAt,
        license:<string>response.data.license,
        licenseUrl:<string>response.data.licenseUrl     
    };
    return postresponse;
}
function convertToPostPublicationResponse(json response) returns PostPublicationResponse {
    PostPublicationResponse postPublicationResponse = {
        id:<string>response.data.id,
        publicationId:<string>response.data.publicationId,
        title:<string>response.data.title,
        authorId:<string>response.data.authorId,
        tags:<json[]>response.data.tags,
        url:<string>response.data.url,
        canonicalUrl:<string>response.data.canonicalUrl,
        publishStatus:<string>response.data.publishStatus,
        publishedAt:<int|error>response.data.publishedAt,
        license:<string>response.data.license,
        licenseUrl:<string>response.data.licenseUrl     
    };
    return postPublicationResponse;
}

function convertToPublication(json response) returns Publication {
    Publication publication = {
        id: <string>response.id,
        name: <string>response.name,
        description: <string>response.description,
        url: <string>response.url,
        imageUrl: <string>response.imageUrl        
    };
    return publication;
}

function convertToImageResponse(json response) returns ImageResponse {
    ImageResponse imageResponse = {
        url: <string>response.data.url,
        md5: <string>response.data.md5     
    };
    return imageResponse;
}


function convertToPublications(json response) returns Publication[] {
    Publication[] publications = [];
    json[] data = <json[]>response.data;
    int i = 0;
    foreach json publication in data {
        publications[i] = convertToPublication(publication);
        i = i + 1;
    }
    return publications;
}

function convertToContributor(json response) returns Contributor {
    Contributor contributor = {
        publicationId: <string>response.publicationId,
        userId: <string>response.userId,
        role: <string>response.role        
    };
    return contributor;
}


function convertToContributors(json response) returns Contributor[] {
    Contributor[] contributors = [];
    json[] data = <json[]>response.data;
    int i = 0;
    foreach json contributor in data {
        contributors[i] = convertToContributor(contributor);
        i = i + 1;
    }
    return contributors;
}