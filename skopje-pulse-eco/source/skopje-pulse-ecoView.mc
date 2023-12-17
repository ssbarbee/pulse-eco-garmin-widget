import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class skopje_pulse_ecoView extends WatchUi.View {
    private var _lines as Array<String>;

    function initialize() {
        View.initialize();
        _lines = ["Initializing..."] as Array<String>;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        // Set background color
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;

        var font = Graphics.FONT_TINY;
        var textHeight = dc.getFontHeight(font);

        y -= (_lines.size() * textHeight) / 2;

        for (var i = 0; i < _lines.size(); ++i) {
            dc.drawText(x, y, font, _lines[i], Graphics.TEXT_JUSTIFY_CENTER);
            y += textHeight;
        }
    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    //! Set the position
    //! @param info Position information
    public function updateView(viewModel as ViewModel) as Void {
        _lines = [] as Array<String>;

        // var position = info.position;
        // if (position != null) {
        //     _lines.add("lat = " + position.toDegrees()[0].toString());
        //     _lines.add("lon = " + position.toDegrees()[1].toString());
        // }

        var loading = viewModel.loading;
        if (loading == true) {
             _lines = [] as Array<String>;
            _lines.add("loading...");
        }

        var error = viewModel.error;
        if (error == true) {
             _lines = [] as Array<String>;
            _lines.add("error happened...");
        }

        var overallModel = viewModel.overallModel.values;
        if (overallModel != null) {
            if (overallModel.pm10 != null) {
                _lines.add("pm10: " + overallModel.pm10 + " μg/m3");
            }
            if (overallModel.pm25 != null) {
                _lines.add("pm25: " + overallModel.pm25 + " μg/m3");
            }
            // if (overallModel.no2 != null) {
            //     _lines.add("no2: " + overallModel.no2 + " µg/m3");
            // }
            // if (overallModel.o3 != null) {
            //     _lines.add("o3: " + overallModel.o3 + " μg/m3");
            // }
            if (overallModel.temperature != null) {
                _lines.add("temperature: " + overallModel.temperature + "°C");
            }
            // if (overallModel.humidity != null) {
            //     _lines.add("humidity: " + overallModel.humidity + "%");
            // }
            // if (overallModel.pressure != null) {
            //     _lines.add("pressure: " + overallModel.pressure + " hPa");
            // }
            // if (overallModel.noiseDba != null) {
            //     _lines.add("noise_dba: " + overallModel.noiseDba + " dBA");
            // }
        }

        WatchUi.requestUpdate();
    }
}
