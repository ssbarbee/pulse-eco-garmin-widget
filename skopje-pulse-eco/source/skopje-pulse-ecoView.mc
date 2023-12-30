import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;

class skopje_pulse_ecoView extends WatchUi.View {
    private var _lines as Array<LineModel> = [];
    private var _progressBar as WatchUi.ProgressBar?;
    private var refreshOverall;
    // Have to delay showing progress bar until Layout has been loaded otherwise it doesnt show
    // maybe we don't need layout?
    private var _queuedProgressBar as Boolean = false;
    function initialize(refreshOverall) {
        View.initialize();
        self.refreshOverall = refreshOverall as Method;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        var isOnboarded = getOnboardedValue();
        var refreshOverall = getRefreshOverall();
        if(isOnboarded and refreshOverall) {
            self._queuedProgressBar = true;
            setRefreshOverall(false);
            self.refreshOverall.invoke();
        }
        if(self._queuedProgressBar) {
            self._showProgressBar();
        }
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        dc.clear();

        var totalTextHeight = 0;
        for (var i = 0; i < _lines.size(); ++i) {
            var font = _lines[i].font != null ? _lines[i].font : Graphics.FONT_TINY;
            totalTextHeight = totalTextHeight + dc.getFontHeight(font);
        }

        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;
        y -= totalTextHeight / 2;

        for (var i = 0; i < _lines.size(); ++i) {
            var font = _lines[i].font != null ? _lines[i].font : Graphics.FONT_TINY;

            var prefixText = _lines[i].prefixText != null ? _lines[i].prefixText : "";
            var text = _lines[i].text != null ? _lines[i].text : "";
            var suffixText = _lines[i].suffixText != null ? _lines[i].suffixText : "";

            var prefixTextColor = _lines[i].prefixTextColor != null ? _lines[i].prefixTextColor : Graphics.COLOR_WHITE;
            var textColor = _lines[i].textColor != null ? _lines[i].textColor : Graphics.COLOR_WHITE;
            var suffixTextColor = _lines[i].suffixTextColor != null ? _lines[i].suffixTextColor : Graphics.COLOR_WHITE;

            var prefixTextWidth = dc.getTextWidthInPixels(prefixText, font);
            var textWidth = dc.getTextWidthInPixels(text, font);

            if(prefixText.length() > 0 and text.length() > 0 and suffixText.length() > 0) {
                dc.setColor(prefixTextColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x - prefixTextWidth, y, font, prefixText, Graphics.TEXT_JUSTIFY_LEFT);
                
                dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x, y, font, text, Graphics.TEXT_JUSTIFY_LEFT);
                
                dc.setColor(suffixTextColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x + textWidth, y, font, suffixText, Graphics.TEXT_JUSTIFY_LEFT);

                y += dc.getFontHeight(font);
            }
            
            if(prefixText.length() == 0 and text.length() > 0 and suffixText.length() == 0) {
                dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x, y, font, text, Graphics.TEXT_JUSTIFY_CENTER);
                y += dc.getFontHeight(font);
            }
            
            if(prefixText.length() == 0 and text.length() > 0 and suffixText.length() > 0) {
                dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x - textWidth, y, font, text, Graphics.TEXT_JUSTIFY_LEFT);
                
                dc.setColor(suffixTextColor, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x, y, font, suffixText, Graphics.TEXT_JUSTIFY_LEFT);

                y += dc.getFontHeight(font);
            }
        }
    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function hideProgressBar() as Void {
        System.println("hideProgressBar");
        _queuedProgressBar = false;
        if(_progressBar != null) {
            _progressBar = null;
            WatchUi.popView(WatchUi.SLIDE_UP);
        }
    }

    function showProgressBar() as Void {
        _queuedProgressBar = true;
        System.println("_queuedProgressBar=true");
    }

    function _showProgressBar() as Void {
        System.println("_showProgressBar");
        _progressBar = new WatchUi.ProgressBar(
            "Fetching...",
            null
        );
        WatchUi.pushView(
            _progressBar,
            null,
            WatchUi.SLIDE_DOWN
        );
    }

    //! Update the view
    //! @param viewModel ViewModel information
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
        } else {
            var showOnboarding = viewModel.showOnboarding;
            if (showOnboarding) {
                _lines = [] as Array<LineModel>;
                _lines.add(new LineModel({
                    :text => "Hold Menu Button to adjust",
                    :font => Graphics.FONT_XTINY
                }));
            } else {
                var error = viewModel.error;
                if (error.length() > 0) {
                    _lines = [] as Array<LineModel>;
                    _lines.add(new LineModel({
                        :text => error,
                        :font => error.length() < 23 ? Graphics.FONT_TINY : Graphics.FONT_XTINY
                    }));
                }

                if(viewModel.overallModel != null) {
                    var overallModel = viewModel.overallModel.values;
                    if (overallModel != null) {
                        if (overallModel.pm10 != null) {
                            var pm10Number = overallModel.pm10.toNumber();
                            var color = getPollutionColorValue(pm10Number);
                            _lines.add(new LineModel({
                                :prefixText => "pm10: ",
                                :text => overallModel.pm10,
                                :suffixText => " μg/m3",
                                :textColor => color
                            }));
                        }
                        if (overallModel.pm25 != null) {
                            var pm25Number = overallModel.pm25.toNumber();
                            var color = getPollutionColorValue(pm25Number);
                            _lines.add(new LineModel({
                                :prefixText => "pm25: ",
                                :text => overallModel.pm25,
                                :suffixText => " μg/m3",
                                :textColor => color
                            }));
                        }
                        // if (overallModel.no2 != null) {
                        //     _lines.add("no2: " + overallModel.no2 + " µg/m3");
                        // }
                        // if (overallModel.o3 != null) {
                        //     _lines.add("o3: " + overallModel.o3 + " μg/m3");
                        // }
                        if (overallModel.temperature != null) {
                            var temperatureNumber = overallModel.temperature.toNumber();
                            var color = getTemperatureColorValue(temperatureNumber);
                            _lines.add(new LineModel({
                                :prefixText => "temp: ",
                                :text => overallModel.temperature,
                                :suffixText => "°C",
                                :textColor => color
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
                        _lines.add(new LineModel({
                            :text => " ",
                            :textColor => Graphics.COLOR_LT_GRAY,
                            :font => Graphics.FONT_TINY
                        }));
                        if(viewModel.cachedDate != null) {
                            var moment = new Moment(viewModel.cachedDate);
                            var cachedDate = Gregorian.info(moment, Time.FORMAT_LONG);
                            _lines.add(new LineModel({
                                :text => "Last updated",
                                :suffixText => Lang.format("$1$:$2$:$3$", [cachedDate.hour.format("%02d"), cachedDate.min.format("%02d"), cachedDate.sec.format("%02d")]),
                                :textColor => Graphics.COLOR_DK_GRAY,
                                :suffixTextColor => Graphics.COLOR_LT_GRAY,
                                :font => Graphics.FONT_XTINY
                            }));
                        }
                        _lines.add(new LineModel({
                            :text => "powered by",
                            :suffixText => " pulse.eco",
                            :textColor => Graphics.COLOR_DK_GRAY,
                            :suffixTextColor => Graphics.COLOR_LT_GRAY,
                            :font => Graphics.FONT_XTINY
                        }));
                    }
                }
            }
            WatchUi.requestUpdate();
        }
    }
}
