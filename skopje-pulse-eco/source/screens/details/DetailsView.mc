import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;

class DetailsView extends WatchUi.View {
    // 0 -> pm10
    // 1 -> pm25
    private var detailsId = 0; 
    private var viewModel; 
    function initialize(detailsId, viewModel as ViewModel) {
        self.detailsId = detailsId;
        self.viewModel = viewModel;
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        dc.clear();      
        if(viewModel.overallModel != null) {
            var overallModel = viewModel.overallModel.values;
            if (overallModel != null) {
                if (detailsId == 0 and overallModel.pm10 != null) {
                    var pm10Number = overallModel.pm10.toNumber();
                    var color = getPollutionColorValue(pm10Number);
                    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                    dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_TINY, pm10Number, Graphics.TEXT_JUSTIFY_LEFT);
                }
                if (detailsId == 1 and overallModel.pm25 != null) {
                    var pm25Number = overallModel.pm25.toNumber();
                    var color = getPollutionColorValue(pm25Number);
                    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                    dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_TINY, pm25Number, Graphics.TEXT_JUSTIFY_LEFT);
                }
            }
        }

    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }
}
