import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Communications;
import Toybox.System;
import Toybox.Position;
import Toybox.Activity;

class skopje_pulse_ecoApp extends Application.AppBase {
    private var _view as skopje_pulse_ecoView;
    private var _settingsDelegate as SettingsDelegate;
    private var viewModel as ViewModel;
    
    function initialize() {
        AppBase.initialize();
        _view = new skopje_pulse_ecoView(method(:fetchOverallData));
        viewModel = new ViewModel(true, true, "", null, null);
        _settingsDelegate = new SettingsDelegate(viewModel);
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ _view, _settingsDelegate ] as Array<Views or InputDelegates>;
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        // var getAllSensorsService = new GetAllSensorsService(method(:handleOnGetAllSensorsSuccess), method(:handleOnGetAllSensorsError));
        // getAllSensorsService.makeRequest();
        var isOnboarded = getOnboardedValue();
        if(isOnboarded) {
            self.fetchOverallData();
        } else {
            self.showOnboarding();
        }

        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    function fetchOverallData() {
        var getOverallService = new GetOverallService(
            method(:handleOnGetOverallSuccess), 
            method(:handleOnGetOverallError), 
            method(:handleOnGetOverallLoading),
            getCitySettingValue()
        );
        getOverallService.makeRequest();
    }

    function onPosition(info as Position.Info) as Void {
        var myLocation = info.position.toDegrees();
        System.println("Latitude: " + myLocation[0]); // e.g. 38.856147
        System.println("Longitude: " + myLocation[1]); // e.g -94.800953
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    function showOnboarding() {
        self.viewModel.loading = false;
        self.viewModel.showOnboarding = true;
        self.viewModel.error = "";
        self.updateUi();
    }

    // function handleOnGetAllSensorsSuccess(sensors as Array<SensorModel>) {
    //     self.viewModel.loading = false;
    //     self.viewModel.showOnboarding = false;
    //     self.viewModel.error = "";
    //     self.updateUi();
    // }

    // function handleOnGetAllSensorsError() {
    //     self.viewModel.loading = false;
    //     self.viewModel.showOnboarding = false;
    //     self.viewModel.error = "error happened...";
    //     self.updateUi();
    // }

    function handleOnGetOverallSuccess(overallModel as OverallModel, cached as Boolean, cachedDate as Number) {
        if(cached == false) {
            self._view.hideProgressBar();
        }
        self.viewModel.loading = false;
        self.viewModel.showOnboarding = false;
        self.viewModel.error = "";
        self.viewModel.overallModel = overallModel;
        self.viewModel.cachedDate = cachedDate;
        self.updateUi();
    }

    function handleOnGetOverallLoading() {
        System.println("handleOnGetOverallLoading");
        self._view.showProgressBar();
    }

    function handleOnGetOverallError(errorMessage as String) {
        self.viewModel.loading = false;
        self.viewModel.showOnboarding = false;
        self.viewModel.error = errorMessage;
        self.viewModel.overallModel = null;
        self._view.hideProgressBar();
        self.updateUi();
    }

    function updateUi() {
        _view.updateView(self.viewModel);
    }
}

function getApp() as skopje_pulse_ecoApp {
    return Application.getApp() as skopje_pulse_ecoApp;
}