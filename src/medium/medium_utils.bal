import ballerina/log;

function generateAuthorizationHeader(Credential mediumCredential) returns string|error {

    string header = "Bearer " + mediumCredential.accessToken;
    return header;
    
}

function prepareErrorResponse(json response) returns error {
    json|error errors = response.errors;
    if (errors is json[]) {
        return prepareError(errors[0].message.toString());
    } else if (errors is json) {
        return prepareError(errors.message.toString());
    } else {
        return prepareError("Error occurred while accessing the JSON payload of the error response.");
    }
}

function prepareError(string message) returns error {
    log:printError(message);
    error twitterError = error(MEDIUM_ERROR_CODE, message = message);
    return twitterError;
}