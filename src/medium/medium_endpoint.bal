import ballerina/http;
import ballerina/io;

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

    public remote function info() returns @tainted Status|error {
        
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
                    return convertToStatus(jsonPayload);
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
};

type Credential record {
    string accessToken;
};

public type Configuration record {
    string accessToken;
    http:ClientConfiguration clientConfig = {};
};