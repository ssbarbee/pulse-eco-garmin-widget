import Toybox.Lang;

class ViewModel {
    public var loading as Boolean;
    public var showOnboarding as Boolean;
    public var error as String;
    public var overallModel as OverallModel?;
    public var cachedDate as Number?;

    public function initialize(
        loading as Boolean,
        showOnboarding as Boolean,
        error as String,
        overAllModel as OverallModel?,
        cachedDate as Number?
    ) {
        self.loading = loading;
        self.showOnboarding = showOnboarding;
        self.error = error;
        self.overallModel = overallModel;
        self.cachedDate = cachedDate;
    }
}
