import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;

class AppView extends WatchUi.View {
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
        System.println("onShow isOnboarded: " + isOnboarded);
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

            renderText({
                :dc => dc,
                :prefixText => _lines[i].prefixText,
                :text => _lines[i].text,
                :suffixText => _lines[i].suffixText,
                :prefixTextColor => _lines[i].prefixTextColor,
                :textColor => _lines[i].textColor,
                :suffixTextColor => _lines[i].suffixTextColor,
                :font => font,
                :x => x,
                :y => y,
            });

            y += dc.getFontHeight(font);
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
                            var color = getPollutionPM10ColorValue(pm10Number);
                            _lines.add(new LineModel({
                                :prefixText => "pm10: ",
                                :text => overallModel.pm10,
                                :suffixText => " μg/m3",
                                :textColor => color
                            }));
                        }
                        if (overallModel.pm25 != null) {
                            var pm25Number = overallModel.pm25.toNumber();
                            var color = getPollutionPM25ColorValue(pm25Number);
                            _lines.add(new LineModel({
                                :prefixText => "pm25: ",
                                :text => overallModel.pm25,
                                :suffixText => " μg/m3",
                                :textColor => color
                            }));
                        }
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
                        _lines.add(new LineModel({
                            :text => " ",
                            :textColor => Graphics.COLOR_LT_GRAY,
                            :font => Graphics.FONT_TINY
                        }));
                        if(viewModel.cachedDate != null) {
                            var moment = new Moment(viewModel.cachedDate);
                            var cachedDate = Gregorian.info(moment, Time.FORMAT_LONG);
                            var citySettingValue = getCitySettingValue();
                            var citySettingValueCapitaliezed = citySettingValue == null ? "" : citySettingValue.toCharArray()[0].toUpper() + citySettingValue.substring(1, null);
                            
                            _lines.add(new LineModel({
                                :text => citySettingValueCapitaliezed.length() > 0 ? citySettingValueCapitaliezed : "Updated",
                                :suffixText => Lang.format(" $1$:$2$:$3$", [cachedDate.hour.format("%02d"), cachedDate.min.format("%02d"), cachedDate.sec.format("%02d")]),
                                :textColor => Graphics.COLOR_DK_GRAY,
                                :suffixTextColor => Graphics.COLOR_LT_GRAY,
                                :font => Graphics.FONT_XTINY
                            }));
                        }

                        _lines.add(new LineModel({
                            :text => "powerd by",
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
