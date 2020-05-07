import ballerina/http;
import ballerina/io;
import ballerina/mime;

# The Medium client object.
public type Client client object {

    http:Client mediumClient;
    Credential mediumCredential;

    public function __init(Configuration mediumConfig) {
        self.mediumClient = new (MEDIUM_API_URL, mediumConfig.clientConfig);
        self.mediumCredential = {
            accessToken: mediumConfig.accessToken
        };
    }

    public remote function myInfo() returns @tainted User|error {

        var header = generateAuthorizationHeader(self.mediumCredential);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }

        http:Request request = new;
        request.setHeader("Host", "api.medium.com");
        request.setHeader("Authorization", <string>header);
        request.setHeader("Content-Type", "application/json");
        request.setHeader("Accept", "application/json");
        request.setHeader("Accept-Charset", "utf-8");
        string requestPath = INFO_API;

        var httpResponse = self.mediumClient->get(requestPath, request);
        if (httpResponse is http:Response) {
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                int statusCode = httpResponse.statusCode;
                if (statusCode == http:STATUS_OK) {
                    io:println(jsonPayload.toString());
                    return convertToUser(jsonPayload);
                } else {
                    return prepareErrorResponse(jsonPayload);
                }
            } else {
                return prepareError("Error occurred while accessing the JSON payload of the response.");
            }
        } else {
            return prepareError("Error occurred while invoking the REST API.");
        }
    }

    public remote function getMyPublications() returns @tainted Publication[]|error {

        var user = self->myInfo();

        var header = generateAuthorizationHeader(self.mediumCredential);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }

        http:Request request = new;
        request.setHeader("Host", "api.medium.com");
        request.setHeader("Authorization", <string>header);
        request.setHeader("Content-Type", "application/json");
        request.setHeader("Accept", "application/json");
        request.setHeader("Accept-Charset", "utf-8");

        if (user is User) {
            string requestPath = USER_API + user.id + PUBLICATIONS;
            var httpResponse = self.mediumClient->get(<@untained>requestPath, request);

            if (httpResponse is http:Response) {
                var jsonPayload = httpResponse.getJsonPayload();
                if (jsonPayload is json) {
                    int statusCode = httpResponse.statusCode;
                    if (statusCode == http:STATUS_OK) {
                        io:println(jsonPayload.toString());
                        return convertToPublications(jsonPayload);
                    } else {
                        return prepareErrorResponse(jsonPayload);
                    }
                } else {
                    return prepareError("Error occurred while accessing the JSON payload of the response.");
                }
            } else {
                return prepareError("Error occurred while invoking the REST API.");
            }

        } else {
            return prepareError("Error in getting user data. ");
        }

    }

    public remote function getUserPublications(string userId) returns @tainted Publication[]|error {

        var header = generateAuthorizationHeader(self.mediumCredential);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }

        http:Request request = new;
        request.setHeader("Host", "api.medium.com");
        request.setHeader("Authorization", <string>header);
        request.setHeader("Content-Type", "application/json");
        request.setHeader("Accept", "application/json");
        request.setHeader("Accept-Charset", "utf-8");


        string requestPath = USER_API + userId + PUBLICATIONS;
        var httpResponse = self.mediumClient->get(<@untained>requestPath, request);

        if (httpResponse is http:Response) {
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                int statusCode = httpResponse.statusCode;
                if (statusCode == http:STATUS_OK) {
                    io:println(jsonPayload.toString());
                    return convertToPublications(jsonPayload);
                } else {
                    return prepareErrorResponse(jsonPayload);
                }
            } else {
                return prepareError("Error occurred while accessing the JSON payload of the response.");
            }
        } else {
            return prepareError("Error occurred while invoking the REST API.");
        }

    }

    public remote function getContributors(string publicationId) returns @tainted Contributor[]|error {

        var header = generateAuthorizationHeader(self.mediumCredential);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }

        http:Request request = new;
        request.setHeader("Host", "api.medium.com");
        request.setHeader("Authorization", <string>header);
        request.setHeader("Content-Type", "application/json");
        request.setHeader("Accept", "application/json");
        request.setHeader("Accept-Charset", "utf-8");


        string requestPath = PUBLICATION_API + publicationId + CONTRIBUTORS;
        var httpResponse = self.mediumClient->get(<@untained>requestPath, request);

        if (httpResponse is http:Response) {
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                int statusCode = httpResponse.statusCode;
                if (statusCode == http:STATUS_OK) {
                    io:println(jsonPayload.toString());
                    return convertToContributors(jsonPayload);
                } else {
                    return prepareErrorResponse(jsonPayload);
                }
            } else {
                return prepareError("Error occurred while accessing the JSON payload of the response.");
            }
        } else {
            return prepareError("Error occurred while invoking the REST API.");
        }

    }

    public remote function createPost(Post post, string userId) returns @tainted PostResponse|error {

        var header = generateAuthorizationHeader(self.mediumCredential);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }

        json body = {
            title: post.title,
            contentFormat: post.contentFormat,
            content: post.content,
            canonicalUrl: post.canonicalUrl,
            tags: post.tags,
            publishStatus: post.publishStatus,
            license: post.license,
            notifyFollowers: post.notifyFollowers
        };


        http:Request request = new;
        request.setHeader("Host", "api.medium.com");
        request.setHeader("Authorization", <string>header);
        request.setHeader("Content-Type", "application/json");
        request.setHeader("Accept", "application/json");
        request.setHeader("Accept-Charset", "utf-8");

        request.setJsonPayload(body);


        string requestPath = USER_API + userId + POSTS;
        var httpResponse = self.mediumClient->post(<@untained>requestPath, request);

        if (httpResponse is http:Response) {
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                int statusCode = httpResponse.statusCode;
                if (statusCode == http:STATUS_CREATED) {
                    io:println(jsonPayload.toString());
                    return convertToPostResponse(jsonPayload);
                } else {
                    return prepareErrorResponse(jsonPayload);
                }
            } else {
                return prepareError("Error occurred while accessing the JSON payload of the response.");
            }
        } else {
            return prepareError("Error occurred while invoking the REST API.");
        }

    }

    public remote function createPostToPublication(Post post, string publicationId) returns @tainted PostPublicationResponse|error {

        var header = generateAuthorizationHeader(self.mediumCredential);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }

        json body = {
            title: post.title,
            contentFormat: post.contentFormat,
            content: post.content,
            canonicalUrl: post.canonicalUrl,
            tags: post.tags,
            publishStatus: post.publishStatus,
            license: post.license,
            notifyFollowers: post.notifyFollowers
        };


        http:Request request = new;
        request.setHeader("Host", "api.medium.com");
        request.setHeader("Authorization", <string>header);
        request.setHeader("Content-Type", "application/json");
        request.setHeader("Accept", "application/json");
        request.setHeader("Accept-Charset", "utf-8");

        request.setJsonPayload(body);


        string requestPath = PUBLICATION_API + publicationId + POSTS;
        var httpResponse = self.mediumClient->post(<@untained>requestPath, request);

        if (httpResponse is http:Response) {
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                int statusCode = httpResponse.statusCode;
                if (statusCode == http:STATUS_CREATED) {
                    io:println(jsonPayload.toString());
                    return convertToPostPublicationResponse(jsonPayload);
                } else {
                    return prepareErrorResponse(jsonPayload);
                }
            } else {
                return prepareError("Error occurred while accessing the JSON payload of the response.");
            }
        } else {
            return prepareError("Error occurred while invoking the REST API.");
        }

    }

    public remote function createImage(Image image) returns @tainted ImageResponse|error {

        var header = generateAuthorizationHeader(self.mediumCredential);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }

        string contentType = mime:IMAGE_PNG;

        if (image.format == "png") {
            contentType = mime:IMAGE_PNG;
        } else if (image.format == "jpeg" || image.format == "jpg") {
            contentType = mime:IMAGE_JPEG;
        } else if (image.format == "gif") {
            contentType = mime:IMAGE_GIF;
        } else if (image.format == "tiff") {
            contentType = "image/tiff";
        }

        mime:Entity pngPart = new;
        pngPart.setContentDisposition(self.getContentDispositionForFormData());
        pngPart.setFileAsEntityBody(image.imageLocation, contentType = contentType);

        http:Request request = new;
        request.setHeader("Host", "api.medium.com");
        request.setHeader("Authorization", <string>header);
        request.setHeader("Accept", "application/json");
        request.setHeader("Accept-Charset", "utf-8");

        mime:Entity[] bodyParts = [pngPart];
        request.setBodyParts(bodyParts, contentType = mime:MULTIPART_FORM_DATA);

        string requestPath = IMAGE_API;
        var httpResponse = self.mediumClient->post(requestPath, request);

        if (httpResponse is http:Response) {
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                int statusCode = httpResponse.statusCode;
                if (statusCode == http:STATUS_CREATED) {
                    io:println(jsonPayload.toString());
                    return convertToImageResponse(jsonPayload);
                } else {
                    return prepareErrorResponse(jsonPayload);
                }
            } else {
                return prepareError("Error occurred while accessing the JSON payload of the response.");
            }
        } else {
            return prepareError("Error occurred while invoking the REST API.");
        }

    }

    function getContentDispositionForFormData() returns (mime:ContentDisposition) {
        mime:ContentDisposition contentDisposition = new;
        contentDisposition.name = "image";
        contentDisposition.fileName = "filename.png";
        contentDisposition.disposition = "form-data";
        return contentDisposition;
    }

};

# Medium Post object
public type Post object {

    string title = "Hello World!";
    string contentFormat = "html";
    string content = "<h1>Hello World!</h1><p>You’ll never walk alone.</p>";
    string canonicalUrl = "";
    string[] tags = [];
    string publishStatus = "public";
    string license = "all-rights-reserved";
    boolean notifyFollowers = false;

    public function setTitle(string temp) {
        self.title = temp;
    }

    public function setContentFormat(string temp) {
        self.contentFormat = temp;
    }

    public function setContent(string temp) {
        self.content = temp;
    }
    public function setCanonicalUrl(string temp) {
        self.canonicalUrl = temp;
    }
    public function setTags(string[] temp) {
        self.tags = temp;
    }
    public function setPublishStatus(string temp) {
        self.publishStatus = temp;
    }
    public function setLicense(string temp) {
        self.license = temp;
    }
    public function setNotifyFollowers(boolean temp) {
        self.notifyFollowers = temp;
    }

};

# Medium image
public type Image object {
    string format = "";
    string imageLocation = "";

    public function setFormat(string temp) {
        self.format = temp;
    }

    public function setImageLocation(string temp) {
        self.imageLocation = temp;
    }
};

type Credential record {
    string accessToken;
};

public type Configuration record {
    string accessToken;
    http:ClientConfiguration clientConfig = {};
};
