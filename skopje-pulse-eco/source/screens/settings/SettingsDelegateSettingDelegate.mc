//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

var cachingItems = [
    new WatchUi.CheckboxMenuItem("15min", null, "15", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}),
    new WatchUi.CheckboxMenuItem("30min", null, "30", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}),
    new WatchUi.CheckboxMenuItem("60min", null, "60", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT})
];

var cityItems = [
    new WatchUi.CheckboxMenuItem("Skopje", null, "skopje", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}),
    new WatchUi.CheckboxMenuItem("Kumanovo", null, "kumanovo", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT})
];

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
        var title = id.equals("caching") ? "Cache duration" : id.equals("city") ? "City: Data Source" : "Unknown setting";
        var items = id.equals("caching") ? cachingItems : id.equals("city") ? cityItems : [];
        if(items.size() == 0) {
            WatchUi.requestUpdate();
        } else {
            var checkMenu = new WatchUi.CheckboxMenu({:title=> new MenuTitle({
                :title => title
            })});
            for(var i = 0; i < items.size(); i++) {
                checkMenu.addItem(items[i]);
                // add check against storage for initial selection
            }
            WatchUi.pushView(checkMenu, new $.Menu2SampleSubMenuDelegate(), WatchUi.SLIDE_UP);
        }
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
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
        for(var i = 0; i < cachingItems.size(); i++) {
            cachingItems[i].setChecked(item.getId() == cachingItems[i].getId());
        }
        for(var i = 0; i < cityItems.size(); i++) {
            cityItems[i].setChecked(item.getId() == cityItems[i].getId());
        }
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
