import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;

class GetAllSensorsService {
    public var onSuccess as Method;
    public var onError as Method;

    public function initialize(onSuccess, onError) {
        self.onSuccess = onSuccess as Method;
        self.onError = onError as Method;
    }

    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        // System.println("onReceive");
        var sensors = new Array<SensorModel>[data.size()];
        if (responseCode == 200) {
            // Handle the response data here
            // System.println("Request Successful " + data[0]["comments"]);
            for(var i=0;i<data.size();i++) {
                var sensorData = data[i];
                var sensorModel = new SensorModel(
                    sensorData["sensorId"],
                    sensorData["position"],
                    sensorData["type"],
                    sensorData["description"],
                    sensorData["comments"],
                    sensorData["status"]
                );
                sensors.add(sensorModel);
            }
            self.onSuccess.invoke(sensors);
        } else {
            // System.println("Response: " + responseCode);
            self.onError.invoke();
        }
    }

    function makeRequest() as Void {
        var url = "https://skopje.pulse.eco/rest/sensor"; 
        var authHeader = "Basic c3NiYXJiZWU6NE1wY2h0NDdDYVVoazdX";

        var headers = {
             // Add the basic authentication header
            "Authorization" => authHeader,
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
        };

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => headers,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON 
        };

        // Make the request
        Communications.makeWebRequest(url, null, options, method(:onReceive));
    }
}