public type User record {
    string id = "";
    string username = "";
    string name = "";
    string url = "";
    string imageUrl = "";

};

public type Publication record {
    string id = "";
    string name = "";
    string description = "";
    string url = "";
    string imageUrl = "";

};

public type ImageResponse record {
    string url = "";
    string md5 = "";
};

public type PostResponse record {
    string id = "";
    string title = "";
    string authorId = "";
    json[] tags = [];
    string url = "";    
    string canonicalUrl = "";    
    string publishStatus = "";    
    int|error publishedAt = 0;    
    string license = "";    
    string licenseUrl = "";    
};
public type PostPublicationResponse record {
    string id = "";
    string publicationId = "";
    string title = "";
    string authorId = "";
    json[] tags = [];
    string url = "";    
    string canonicalUrl = "";    
    string publishStatus = "";    
    int|error publishedAt = 0;    
    string license = "";    
    string licenseUrl = "";    
};

public type Contributor record {
    string publicationId = "";
    string userId = "";
    string role = "";
};
