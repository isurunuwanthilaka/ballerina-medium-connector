import ballerina/stringutils;
import ballerina/test;
import ballerina/system;

Configuration mediumConfig = {
    accessToken: system:getEnv("ACCESS_TOKEN")
};
Client mediumClient = new(mediumConfig);

@test:Config {}
function testUserInfo() {
    var infoResponse = mediumClient->userInfo();

    if (infoResponse is User) {
        test:assertTrue(stringutils:contains("", ""), "Failed to call info()");
    } else {
        test:assertFail(<string>infoResponse.detail()["message"]);
    }
}

@test:Config {}
function testGetPublications() {
    var infoResponse = mediumClient->getPublications();

    if (infoResponse is Publication[]) {
        test:assertTrue(stringutils:contains("", ""), "Failed to call info()");
    } else {
        test:assertFail(<string>infoResponse.detail()["message"]);
    }
}

