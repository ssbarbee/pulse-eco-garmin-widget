import Toybox.Lang;

class OverallValuesModel {
    public var no2 as String;
    public var o3 as String;
    public var pm25 as String;
    public var pm10 as String;
    public var temperature as String;
    public var humidity as String;
    public var pressure as String;
    public var noiseDba as String;

    public function initialize(
        no2 as String,
        o3 as String,
        pm25 as String,
        pm10 as String,
        temperature as String,
        humidity as String,
        pressure as String,
        noiseDba as String
    ) {
        self.no2 = no2;
        self.o3 = o3;
        self.pm25 = pm25;
        self.pm10 = pm10;
        self.temperature = temperature;
        self.humidity = humidity;
        self.pressure = pressure;
        self.noiseDba = noiseDba;
    }
}

class OverallModel {
    public var cityName as String;
    public var values as OverallValuesModel;

    public function initialize(cityName as String, values as OverallValuesModel) {
        self.cityName = cityName;
        self.values = values;
    }
}
