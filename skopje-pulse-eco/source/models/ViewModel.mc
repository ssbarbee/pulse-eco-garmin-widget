import Toybox.Lang;

class ViewModel {
    public var loading as Boolean;
    public var error as String;
    public var overallModel as OverallModel?;

    public function initialize(loading as Boolean, error as String, overAllModel as OverallModel?) {
        self.loading = loading;
        self.error = error;
        self.overallModel = overallModel;
    }
}