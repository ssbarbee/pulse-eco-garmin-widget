import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;

class DetailsView extends WatchUi.View {
    // 0 -> pm10
    // 1 -> pm25
    private var detailsId = 0;
    private var viewModel;
    hidden var _textArea;

    function initialize(detailsId, viewModel as ViewModel) {
        self.detailsId = detailsId;
        self.viewModel = viewModel;
        View.initialize();
    }

    function getMessage() {
        var overallModel = viewModel.overallModel.values;
        var pm10Number = overallModel.pm10.toNumber();
        var pm25Number = overallModel.pm25.toNumber();
        var value = self.detailsId == 0 ? pm10Number : pm25Number;

        // pm10
        if (self.detailsId == 0) {
            if (value > PM10_VERY_BAD_AIR_QUALITY_UPPER_BOUND) {
                return "Hazardous air quality! This would trigger a health warnings of emergency conditions. The entire population is more likely to be affected!";
            }
            if (value > PM10_BAD_AIR_QUALITY_UPPER_BOUND) {
                return "Very bad air quality. Everyone may begin to experience some adverse health effects, and members of the sensitive groups may experience more serious effects.";
            }
            if (value > PM10_MODERATE_AIR_QUALITY_UPPER_BOUND) {
                return "Bad air quality. Unhealthy for Sensitive Groups, people with heart lung disease, older adults and children.";
            }
            if (value > PM10_GOOD_AIR_QUALITY_UPPER_BOUND) {
                return "Moderate air quality. Air quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people.";
            }
            return "Good air quality. Air quality is considered satisfactory, and air pollution poses little or no risk";
        }

        // pm25
        if (self.detailsId == 1) {
            if (value > PM25_VERY_BAD_AIR_QUALITY_UPPER_BOUND) {
                return "Hazardous air quality! This would trigger a health warnings of emergency conditions. The entire population is more likely to be affected!";
            }
            if (value > PM25_BAD_AIR_QUALITY_UPPER_BOUND) {
                return "Very bad air quality. Everyone may begin to experience some adverse health effects, and members of the sensitive groups may experience more serious effects.";
            }
            if (value > PM25_MODERATE_AIR_QUALITY_UPPER_BOUND) {
                return "Bad air quality. Unhealthy for Sensitive Groups, people with heart lung disease, older adults and children.";
            }
            if (value > PM25_GOOD_AIR_QUALITY_UPPER_BOUND) {
                return "Moderate air quality. Air quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people.";
            }
            return "Good air quality. Air quality is considered satisfactory, and air pollution poses little or no risk";
        }

        return "Not supported details view.";
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        if (viewModel.overallModel != null) {
            var message = self.getMessage();
            _textArea = new WatchUi.TextArea({
                :text => message.toString(),
                :color => Graphics.COLOR_WHITE,
                :font => [Graphics.FONT_XTINY],
                :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                :locY => (dc.getHeight() * 1) / 3.3,
                :width => (dc.getWidth() * 5.3) / 6,
                :height => dc.getHeight(),
            });
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {}

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        dc.clear();
        if (viewModel.overallModel != null) {
            var overallModel = viewModel.overallModel.values;
            if (overallModel != null) {
                var font = Graphics.FONT_XTINY;
                if (detailsId == 0 and overallModel.pm10 != null) {
                    var pm10Number = overallModel.pm10.toNumber();

                    renderText({
                        :dc => dc,
                        :prefixText => "pm10: ",
                        :text => overallModel.pm10,
                        :suffixText => " μg/m3",
                        :textColor => getPollutionPM10ColorValue(pm10Number),
                        :font => font,
                        :y => dc.getHeight() / 5,
                    });

                    self._textArea.draw(dc);
                }
                if (detailsId == 1 and overallModel.pm25 != null) {
                    var pm25Number = overallModel.pm25.toNumber();

                    renderText({
                        :dc => dc,
                        :prefixText => "pm25: ",
                        :text => overallModel.pm25,
                        :suffixText => " μg/m3",
                        :textColor => getPollutionPM10ColorValue(pm25Number),
                        :font => font,
                        :y => dc.getHeight() / 5,
                    });
                    self._textArea.draw(dc);
                }
            }
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {}
}
