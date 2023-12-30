//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

var cityItems as Array<WatchUi.CheckboxMenuItem> = [
    new WatchUi.CheckboxMenuItem("Skopje", null, "skopje", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}),
    new WatchUi.CheckboxMenuItem("Strumica", null, "strumica", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT})
];
var selectedCity = null;
//! This is the menu input delegate for the settings menu of the application
class SettingsDelegateSettingDelegate extends WatchUi.Menu2InputDelegate {
    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String;
        if(id.equals("done")) {
            System.println("onSelect done");
            self.onBack();
            WatchUi.requestUpdate();
            return;
        }

        var title = id.equals("city") ? "City: Data Source" : "Unknown setting";
        var items = id.equals("city") ? cityItems : [];
        if(items.size() == 0) {
            WatchUi.requestUpdate();
            return;
        } 

        var checkMenu = new WatchUi.CheckboxMenu({:title=> new MenuTitle({
            :title => title
        })});
        for(var i = 0; i < items.size(); i++) {
            if(items[i].getId().equals(getCitySettingValue())) {
                selectedCity = items[i].getId();
                items[i].setChecked(true);
            }

            checkMenu.addItem(items[i]);
            // add check against storage for initial selection
        }
        WatchUi.pushView(checkMenu, new $.Menu2SampleSubMenuDelegate(), WatchUi.SLIDE_UP);
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        var isOnboarded = getOnboardedValue();
        System.println("onBack isOnboarded: " + isOnboarded);
        if(!isOnboarded) {
            if(selectedCity == null) {
                WatchUi.showToast("Select a city!", null);
                return;
            }
            if(selectedCity != null) {
                setCityValue(selectedCity);
                setRefreshOverall(true);
                WatchUi.popView(WatchUi.SLIDE_DOWN);
                return;
            }
        }
        if(isOnboarded) {
            if(selectedCity != null) {
                setCityValue(selectedCity);
                setRefreshOverall(true);
                WatchUi.popView(WatchUi.SLIDE_DOWN);
                return;
            } else {
                WatchUi.popView(WatchUi.SLIDE_DOWN);
                return;
            }
        }
    }
}

//! This is the menu input delegate shared by all the basic sub-menus in the application
class Menu2SampleSubMenuDelegate extends WatchUi.Menu2InputDelegate {

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        for(var i = 0; i < cityItems.size(); i++) {
            cityItems[i].setChecked(item.getId().equals(cityItems[i].getId()));
        }
        selectedCity = item.getId();
        WatchUi.requestUpdate();
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle the done item being selected
    public function onDone() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
