import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Application.Storage;

class GetOverallService {
    public var onSuccess as Method;
    public var onError as Method;
    public var onLoading as Method;
    public var city as String;
    private var _CACHED_DATE_KEY = "GetOverallService.cachedDate";
    private var _CACHED_DATA_KEY = "GetOverallService.cachedData";
    // private var _CACHE_DURATION_SECONDS = 60 * 15; // 15 Minutes
    private var _CACHE_DURATION_SECONDS = 1; // 15 Minutes

    public function initialize(onSuccess, onError, onLoading, city) {
        self.onSuccess = onSuccess as Method;
        self.onLoading = onLoading as Method;
        self.onError = onError as Method;
        self.city = city as String;
    }

    function mapToOverallModel(data as Dictionary) as OverallModel {
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
        return new OverallModel(data["cityName"], overallValuesModel);
    }

    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        var timestampNow = Time.now().value();
        // System.println("onReceive");
        if (responseCode == 200 and data != null) {
            Storage.setValue(self._CACHED_DATE_KEY + "." + self.city , timestampNow);
            Storage.setValue(self._CACHED_DATA_KEY + "." + self.city, data);
            var overallModel = self.mapToOverallModel(data);
            self.onSuccess.invoke(overallModel, false, timestampNow);
        } else {
            var message = ERROR_CODE_MESSAGES.get(responseCode);
            var errorMessage = message != null ? message : 
                ("Oops! Somethings wrong! " + responseCode);
            self.onError.invoke(errorMessage);
        }
    }

    function makeRequest() as Void {
        var timestampNow = Time.now().value();
        var cachedDate = Storage.getValue(self._CACHED_DATE_KEY + "." + self.city);
        var cachedData = null;
        if( cachedDate != null ) {
            if ( timestampNow - cachedDate >= self._CACHE_DURATION_SECONDS ) {
                // expired cache
                Storage.deleteValue(self._CACHED_DATE_KEY + "." + self.city);
                Storage.deleteValue(self._CACHED_DATA_KEY + "." + self.city);
            } else {
                cachedData = Storage.getValue(self._CACHED_DATA_KEY + "." + self.city);
            }
        }
        if( cachedData != null ) {
            var overallModel = self.mapToOverallModel(cachedData);
            self.onSuccess.invoke(overallModel, true, cachedDate);
            return;        
        }

        self.onLoading.invoke();
        var url = "https://" + self.city + ".pulse.eco/rest/overall"; 
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Authorization" => "Basic c3NiYXJiZWU6NE1wY2h0NDdDYVVoazdX",
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON 
        };

        // Make the request
        System.println("Making webrequest against: " + url);
        Communications.makeWebRequest(url, null, options, method(:onReceive));
    }
}