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