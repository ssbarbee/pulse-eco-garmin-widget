import Toybox.Lang;

enum SensorType {
    MOEPP = "0",                            // MOEPP measurement station
    SkopjePulseLoRaWAN = "1",                // SkopjePulse LoRaWAN based sensor, version 1
    SkopjePulseWiFi = "2",                   // SkopjePulse WiFi based sensor, version 1
    PulseEcoWiFi = "3",                     // pulse.eco WiFi based sensor, version 2
    PulseEcoLoRaWAN = "4",                  // pulse.eco LoRaWAN based sensor, version 2
    PengyDevice = "20001",                  // pengy device, version 1
    URADMonitor = "20002",                  // URAD Monitor device
    AirThingsPlatform = "20003",            // AirThings platform device
    SensorCommunity = "20004"               // sensor.community crowdsourced device
}

enum SensorStatus {
    REQUESTED = "REQUESTED",                // A user requested this location with a device ID, but not sending data yet
    ACTIVE = "ACTIVE",                      // The sensor is up and running properly
    ACTIVE_UNCONFIRMED = "ACTIVE_UNCONFIRMED", // The sensor is up and running properly but not yet confirmed by the community lead
    INACTIVE = "INACTIVE",                  // The sensor is registered but turned off and ignored
    NOT_CLAIMED = "NOT_CLAIMED",            // The sensor is registered, but so far not bound to an owner
    NOT_CLAIMED_UNCONFIRMED = "NOT_CLAIMED_UNCONFIRMED", // The sensor is registered, but so far not bound to an owner nor confirmed by the community lead
    BANNED = "BANNED"                       // The sensor is manually removed from evidence in order to keep data sanity
}

class SensorModel {
    public var sensorId as String;
    public var position as String;
    public var type as SensorType;
    public var description as String;
    public var comments as String;
    public var status as SensorStatus;

    public function initialize(sensorId as String, position as String, type as String, description as String, comments as String, status as String) {
        self.sensorId = sensorId;
        self.position = position;
        self.type = type as SensorType;
        self.description = description;
        self.comments = comments;
        self.status = status as SensorStatus;
    }
}