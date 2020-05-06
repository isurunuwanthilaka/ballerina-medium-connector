import ballerina/stringutils;
import ballerina/test;
import ballerina/system;

Configuration mediumConfig = {
    accessToken: system:getEnv("ACCESS_TOKEN")
};

Client mediumClient = new(mediumConfig);

@test:Config {}
function testUserInfo() {
    var infoResponse = mediumClient->myInfo();

    if (infoResponse is User) {
        test:assertTrue(stringutils:contains("", ""), "Failed to call info()");
    } else {
        test:assertFail(<string>infoResponse.detail()["message"]);
    }
}

@test:Config {}
function testGetMyPublications() {
    var infoResponse = mediumClient->getMyPublications();

    if (infoResponse is Publication[]) {
        test:assertTrue(stringutils:contains("", ""), "Failed to call info()");
    } else {
        test:assertFail(<string>infoResponse.detail()["message"]);
    }
}

@test:Config {}
function testGetUserPublications() {
    var infoResponse = mediumClient->getUserPublications("19ee90b2494c92e1bcd33a6654c27ba234e934ac2d9d9af8394231ee7bc26affa");

    if (infoResponse is Publication[]) {
        test:assertTrue(stringutils:contains("", ""), "Failed to call info()");
    } else {
        test:assertFail(<string>infoResponse.detail()["message"]);
    }
}

@test:Config {}
function testGetContributors() {
    var infoResponse = mediumClient->getContributors("ca02ee322ac2");

    if (infoResponse is Contributor[]) {
        test:assertTrue(stringutils:contains("", ""), "Failed to call info()");
    } else {
        test:assertFail(<string>infoResponse.detail()["message"]);
    }
}


