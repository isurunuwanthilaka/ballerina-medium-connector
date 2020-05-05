function convertToStatus(json response) returns Status {
    Status status = {
        id: <string>response.data.id,
        username: <string>response.data.username,
        name: <string>response.data.name,
        url: <string>response.data.url,
        imageUrl: <string>response.data.imageUrl        
    };
    return status;
}

function convertToStatuses(json[] response) returns Status[] {
    Status[] statuses = [];
    int i = 0;
    foreach json status in response {
        statuses[i] = convertToStatus(status);
        i = i + 1;
    }
    return statuses;
}