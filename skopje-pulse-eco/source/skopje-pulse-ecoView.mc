import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class LineModel {
    public var prefixText as String;
    public var text as String;
    public var suffixText as String;
    public var prefixTextColor as Number;
    public var textColor as Number;
    public var suffixTextColor as Number;

    public function initialize(
        params as { 
            :prefixText as String, 
            :text as String, 
            :suffixText as String, 
            :prefixTextColor as Number,
            :textColor as Number,
            :suffixTextColor as Number
        }) {
        self.prefixText = params.get(:prefixText);
        self.text = params.get(:text);
        self.suffixText = params.get(:suffixText);
        self.prefixTextColor = params.get(:prefixTextColor);
        self.textColor = params.get(:textColor);
        self.suffixTextColor = params.get(:suffixTextColor);
    }
}

class skopje_pulse_ecoView extends WatchUi.View {
    private var _lines as Array<LineModel>;

    function initialize() {
        View.initialize();
        _lines = [new LineModel({
            :prefixText => "",
            :text => "Initializing...",
            :suffixText => "",
            :prefixTextColor => Graphics.COLOR_WHITE,
            :textColor => Graphics.COLOR_WHITE,
            :suffixTextColor => Graphics.COLOR_WHITE,
        })] as Array<LineModel>;
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
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;

        var font = Graphics.FONT_TINY;
        var textHeight = dc.getFontHeight(font);

        y -= (_lines.size() * textHeight) / 2;

        for (var i = 0; i < _lines.size(); ++i) {
            System.println(_lines[i].prefixText);
            if(_lines[i].prefixText.length() > 0 and _lines[i].text.length() > 0 and _lines[i].suffixText.length() > 0) {
                dc.setColor(_lines[i].prefixTextColor, Graphics.COLOR_TRANSPARENT);
                var prefixTextWidth = dc.getTextWidthInPixels(_lines[i].prefixText, font);
                dc.drawText(x - prefixTextWidth, y, font, _lines[i].prefixText, Graphics.TEXT_JUSTIFY_LEFT);
                
                dc.setColor(_lines[i].textColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x, y, font, _lines[i].text, Graphics.TEXT_JUSTIFY_LEFT);
                
                var textWidth = dc.getTextWidthInPixels(_lines[i].text, font);
                dc.setColor(_lines[i].suffixTextColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x + textWidth, y, font, _lines[i].suffixText, Graphics.TEXT_JUSTIFY_LEFT);

                y += textHeight;
            }
            if(_lines[i].prefixText.length() == 0 and _lines[i].text.length() > 0 and _lines[i].suffixText.length() == 0) {
                dc.setColor(_lines[i].textColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x, y, font, _lines[i].text, Graphics.TEXT_JUSTIFY_CENTER);
                y += textHeight;
            }
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
        _lines = [] as Array<LineModel>;

        // var position = info.position;
        // if (position != null) {
        //     _lines.add("lat = " + position.toDegrees()[0].toString());
        //     _lines.add("lon = " + position.toDegrees()[1].toString());
        // }

        var loading = viewModel.loading;
        if (loading == true) {
             _lines = [] as Array<LineModel>;
            _lines.add(new LineModel({
                :prefixText => "",
                :text => "loading...",
                :suffixText => "",
                :prefixTextColor => Graphics.COLOR_WHITE,
                :textColor => Graphics.COLOR_WHITE,
                :suffixTextColor => Graphics.COLOR_WHITE,
            }));
        }

        var error = viewModel.error;
        if (error.length() > 0) {
             _lines = [] as Array<LineModel>;
             _lines.add(new LineModel({
                :prefixText => "",
                :text => error,
                :suffixText => "",
                :prefixTextColor => Graphics.COLOR_WHITE,
                :textColor => Graphics.COLOR_WHITE,
                :suffixTextColor => Graphics.COLOR_WHITE,
            }));
        }

        if(viewModel.overallModel != null) {
            var overallModel = viewModel.overallModel.values;
            if (overallModel != null) {
                if (overallModel.pm10 != null) {
                    var color = Graphics.COLOR_DK_GREEN;
                    var pm10Number = overallModel.pm10.toNumber();
                    if(pm10Number > 40) {
                        color = Graphics.COLOR_ORANGE;
                    }
                    if(pm10Number > 80) {
                        color = Graphics.COLOR_DK_RED;
                    }
                    _lines.add(new LineModel({
                        :prefixText => "pm10: ",
                        :text => overallModel.pm10,
                        :suffixText => " μg/m3",
                        :prefixTextColor => Graphics.COLOR_WHITE,
                        :textColor => color,
                        :suffixTextColor => Graphics.COLOR_WHITE,
                    }));
                }
                if (overallModel.pm25 != null) {
                    var color = Graphics.COLOR_DK_GREEN;
                    var pm25Number = overallModel.pm25.toNumber();
                    if(pm25Number > 40) {
                        color = Graphics.COLOR_ORANGE;
                    }
                    if(pm25Number > 80) {
                        color = Graphics.COLOR_DK_RED;
                    }
                    _lines.add(new LineModel({
                        :prefixText => "pm25: ",
                        :text => overallModel.pm25,
                        :suffixText => " μg/m3",
                        :prefixTextColor => Graphics.COLOR_WHITE,
                        :textColor => color,
                        :suffixTextColor => Graphics.COLOR_WHITE,
                    }));
                }
                // if (overallModel.no2 != null) {
                //     _lines.add("no2: " + overallModel.no2 + " µg/m3");
                // }
                // if (overallModel.o3 != null) {
                //     _lines.add("o3: " + overallModel.o3 + " μg/m3");
                // }
                if (overallModel.temperature != null) {
                    _lines.add(new LineModel({
                        :prefixText => "temp: ",
                        :text => overallModel.temperature,
                        :suffixText => "°C",
                        :prefixTextColor => Graphics.COLOR_WHITE,
                        :textColor => Graphics.COLOR_WHITE,
                        :suffixTextColor => Graphics.COLOR_WHITE,
                    }));
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
        }
        WatchUi.requestUpdate();
    }
}
