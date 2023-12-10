import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;

class GetAllSensors {
    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            System.println("Request Successful");
            // Handle the response data here
        } else {
            System.println("Response: " + responseCode);
        }
    }

    function makeRequest() as Void {
        var url = "https://skopje.pulse.eco/rest/sensor"; // Set the API endpoint
        var authHeader = "Basic c3NiYXJiZWU6NE1wY2h0NDdDYVVoazdX";

        var headers = {
            "Authorization" => authHeader, // Add the basic authentication header
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
        };

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => headers,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON // Set the response type
        };

        // Make the request
        Communications.makeWebRequest(url, null, options, method(:onReceive));
    }
}