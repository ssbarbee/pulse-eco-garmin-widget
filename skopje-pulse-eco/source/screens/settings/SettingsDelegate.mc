//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! This delegate is for the main page of our application that pushes the menu
//! when the onMenu() behavior is received.
class SettingsDelegate extends WatchUi.BehaviorDelegate {

    //! Constructor
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    //! Handle the menu event
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        // Generate a new Menu with a drawable Title
        var menu = new WatchUi.Menu2({:title=>new MenuTitle({
            :title => "Fine-Tune"
        })});

        menu.addItem(new WatchUi.MenuItem("City", null, "city", null));
        menu.addItem(new WatchUi.MenuItem("Caching", null, "caching", null));
        WatchUi.pushView(menu, new SettingsDelegateSettingDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}

//! This is the custom drawable we will use for our main menu title
class MenuTitle extends WatchUi.Drawable {
    private var title as String;
    //! Constructor
    public function initialize(params as { 
            :title as String, 
    }) {
        self.title = params.get(:title);
        Drawable.initialize({});
    }

    //! Draw the application icon and main menu title
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_XTINY, self.title, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
