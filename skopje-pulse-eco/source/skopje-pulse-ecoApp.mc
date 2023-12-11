import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Communications;
import Toybox.System;

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