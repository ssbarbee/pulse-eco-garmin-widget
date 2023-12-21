import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;

class GetOverallService {
    public var onSuccess as Method;
    public var onError as Method;

    public function initialize(onSuccess, onError) {
        self.onSuccess = onSuccess as Method;
        self.onError = onError as Method;
    }

    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        // System.println("onReceive");
        if (responseCode == 200 and data != null) {
            var values = data["values"];
            var overallValuesModel = new OverallValuesModel(
                values["no2"],
                values["o3"],
                values["pm25"],
                values["pm10"],
                values["temperature"],
                values["humidity"],
                values["pressure"],
                values["noiseDba"]
            );
            var overallModel = new OverallModel(data["cityName"], overallValuesModel);
            self.onSuccess.invoke(overallModel);
        } else {
            System.println("Response: " + responseCode);
            var errorMessage = "Oops! Somethings wrong!";
            if(responseCode == -104) {
                errorMessage = "Connect WiFi!";
            }
            self.onError.invoke(errorMessage);
        }
    }

    function makeRequest() as Void {
        var url = "https://skopje.pulse.eco/rest/overall"; 
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Authorization" => "Basic c3NiYXJiZWU6NE1wY2h0NDdDYVVoazdX",
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON 
        };

        // Make the request
        Communications.makeWebRequest(url, null, options, method(:onReceive));
    }
}