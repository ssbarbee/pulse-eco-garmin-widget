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
    private var viewModel as ViewModel;

    //! Constructor
    public function initialize(viewModel as ViewModel) {
        self.viewModel = viewModel;
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
        menu.addItem(new WatchUi.MenuItem("Done", null, "done", null));
        WatchUi.pushView(menu, new SettingsDelegateSettingDelegate(method(:onOnboardingFinish)), WatchUi.SLIDE_UP);

        return true;
    }

    public function onOnboardingFinish() {
        self.viewModel.showOnboarding = false;
    }

    //! Handle going to the next view
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        if(self.viewModel.overallModel == null) {
            return true;
        }

        System.println("Next page event");
        var view = new DetailsView(0, self.viewModel);
        WatchUi.pushView(view, new DetailsDelegate(self.viewModel), WatchUi.SLIDE_UP);
        return true;
    }
}

//! This delegate is for the main page of our application that pushes the menu
//! when the onMenu() behavior is received.
class DetailsDelegate extends WatchUi.BehaviorDelegate {
    private var detailsId = 0;
    private var viewModel as ViewModel;
    //! Constructor
    public function initialize(viewModel as ViewModel) {
        self.viewModel = viewModel;
        BehaviorDelegate.initialize();
    }

    //! Handle going to the next view
    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        if(self.viewModel.overallModel == null) {
            return true;
        }
        System.println("Next page event");
        var nextDetailsId = (self.detailsId + 1) % 2;
        var view = new DetailsView(nextDetailsId, self.viewModel);
        self.detailsId = nextDetailsId;
        WatchUi.switchToView(view, self, WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! Handle going to the previous view
    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        if(self.viewModel.overallModel == null) {
            return true;
        }
        System.println("Previous page event");
        var nextDetailsId = (self.detailsId - 1) % 2;
        var view = new DetailsView(nextDetailsId, self.viewModel);
        self.detailsId = nextDetailsId;
        WatchUi.switchToView(view, self, WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}

//! This is the custom drawable we will use for our main menu title
class MenuTitle extends WatchUi.Drawable {
    public var title as String;
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
