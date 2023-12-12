import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Communications;
import Toybox.System;
import Toybox.Position;
import Toybox.Activity;

class skopje_pulse_ecoApp extends Application.AppBase {
    var loading as Boolean = false;
    var error as Boolean = false;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        self.loading = true;
        // Create an instance of SensorDataRequest and make the API request
        var getAllSensorsService = new GetAllSensorsService(method(:handleOnGetAllSensorsSuccess), method(:handleOnGetAllSensorsError));
        getAllSensorsService.makeRequest();

        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));

        var curLoc = Activity.Info.currentLocation;
        if (curLoc != null) {
            var long = curLoc.toDegrees()[1].toFloat();
            var lat = curLoc.toDegrees()[0].toFloat();
            System.println("Activity.Latitude: " + lat); // e.g. 38.856147
            System.println("Activity.Longitude: " + long); // e.g -94.800953
        } else {
            System.println("No location found"); // e.g -94.800953
        }
    }

    function onPosition(info as Position.Info) as Void {
        var myLocation = info.position.toDegrees();
        System.println("Latitude: " + myLocation[0]); // e.g. 38.856147
        System.println("Longitude: " + myLocation[1]); // e.g -94.800953
    }

    function onShow() {
        System.println("onShowFired"); // e.g -94.800953
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    function onHide() {
        System.println("onHideFired"); // e.g -94.800953
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }


    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new skopje_pulse_ecoView() ] as Array<Views or InputDelegates>;
    }

    function handleOnGetAllSensorsSuccess(sensors as Array<SensorModel>) {
        self.loading = false;
        self.error = false;
        System.println("handleOnGetAllSensorsSuccess");
        System.println("handleOnGetAllSensorsSuccess" + sensors.size());
    }

    function handleOnGetAllSensorsError() {
        self.loading = false;
        self.error = true;
        System.println("handleOnGetAllSensorsError");
    }
}

function getApp() as skopje_pulse_ecoApp {
    return Application.getApp() as skopje_pulse_ecoApp;
}