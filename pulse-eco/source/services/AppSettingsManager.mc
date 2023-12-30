
import Toybox.Application.Storage;
import Toybox.Lang;

var DEFAULT_CITY_VALUE = "skopje";

function getCitySettingValue() {
    var storedValue = Storage.getValue("AppSettings.city");
    if(storedValue == null) {
        return DEFAULT_CITY_VALUE;
    }

    return storedValue;
}

function getOnboardedValue() {
    var storedValue = Storage.getValue("AppSettings.onboarded");
    if(storedValue == null) {
        return false;
    }
    
    return storedValue;
}

function getRefreshOverall() {
    var storedValue = Storage.getValue("AppSettings.refreshOverall");
    if(storedValue == null) {
        return false;
    }
    
    return storedValue;
}

function setCityValue(value as String) {
    Storage.setValue("AppSettings.city", value);
}

function setOnboardedValue(value as Boolean) {
    Storage.setValue("AppSettings.onboarded", value);
}

function setRefreshOverall(value as Boolean) {
    Storage.setValue("AppSettings.refreshOverall", value);
}