import ballerina/stringutils;
import ballerina/test;
import ballerina/system;

Configuration mediumConfig = {
    accessToken: system:getEnv("ACCESS_TOKEN")
};
Client mediumClient = new(mediumConfig);

@test:Config {}
function testInfo() {
    var infoResponse = mediumClient->info();

    if (infoResponse is Status) {
        test:assertTrue(stringutils:contains("", ""), "Failed to call info()");
    } else {
        test:assertFail(<string>infoResponse.detail()["message"]);
    }
}