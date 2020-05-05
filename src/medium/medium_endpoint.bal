import ballerina/encoding;
import ballerina/http;

# The Twitter client object.
public type Client client object {

    http:Client twitterClient;
    Credential twitterCredential;

    public function __init(Configuration twitterConfig) {
        self.twitterClient = new(TWITTER_API_URL, twitterConfig.clientConfig);
        self.twitterCredential = {
            accessToken: twitterConfig.accessToken,
            accessTokenSecret: twitterConfig.accessTokenSecret,
            consumerKey: twitterConfig.consumerKey,
            consumerSecret: twitterConfig.consumerSecret
        };
    }

    # Updates the authenticating user's current status, also known as Tweeting.
    #
    # + status - The text of status update
    # + return - If success, returns `twitter:Status` object, else returns `error`
    public remote function tweet(string status) returns @tainted Status|error {
        var encodedStatus = encoding:encodeUriComponent(status, UTF_8);
        if (encodedStatus is error) {
            return prepareError("Error occurred while encoding the status.");
        }
        string urlParams = "status=" + <string>encodedStatus;

        var header = generateAuthorizationHeader(self.twitterCredential, POST, UPDATE_API, urlParams);
        if (header is error) {
            return prepareError("Error occurred while generating authorization header.");
        }
        http:Request request = new;
        request.setHeader("Authorization", <string>header);
        string requestPath = UPDATE_API + "?" + urlParams;

        var httpResponse = self.twitterClient->post(requestPath, request);
        if (httpResponse is http:Response) {
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                int statusCode = httpResponse.statusCode;
                if (statusCode == http:STATUS_OK) {
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
}