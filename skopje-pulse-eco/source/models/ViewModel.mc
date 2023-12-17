import Toybox.Lang;

class ViewModel {
    public var loading as Boolean;
    public var error as Boolean;
    public var overallModel as OverallModel?;

    public function initialize(loading as Boolean, error as Boolean, overAllModel as OverallModel?) {
        self.loading = loading;
        self.error = error;
        self.overallModel = overallModel;
    }
}