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
        if (responseCode == 200) {
            var dataSize = 0;
            if (data != null) {
                dataSize = data.size();
            }
            var sensors = new Array<SensorModel>[dataSize];
            // Handle the response data here
            for (var i = 0; i < dataSize; i++) {
                var sensorData = data[i] as Dictionary;
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
            self.onError.invoke();
        }
    }

    function makeRequest() as Void {
        var url = "https://skopje.pulse.eco/rest/sensor";
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Authorization" => "Basic c3NiYXJiZWU6NE1wY2h0NDdDYVVoazdX",
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED,
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
        };

        // Make the request
        Communications.makeWebRequest(url, null, options, method(:onReceive));
    }
}
