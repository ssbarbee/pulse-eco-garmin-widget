import Toybox.Lang;

class ViewModel {
    public var loading as Boolean;
    public var error as Boolean;

    public function initialize(loading as Boolean, error as Boolean) {
        self.loading = loading;
        self.error = error;
    }
}