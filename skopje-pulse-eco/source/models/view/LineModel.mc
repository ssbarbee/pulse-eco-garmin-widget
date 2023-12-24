import Toybox.Lang;

class LineModel {
    public var prefixText as String?;
    public var text as String?;
    public var suffixText as String?;
    public var prefixTextColor as Number?;
    public var textColor as Number?;
    public var suffixTextColor as Number?;
    public var font as Number?;

    public function initialize(
        params as { 
            :prefixText as String?, 
            :text as String?, 
            :suffixText as String?, 
            :prefixTextColor as Number?,
            :textColor as Number?,
            :suffixTextColor as Number?,
            :font as Number?
        }) {
        self.prefixText = params.get(:prefixText);
        self.text = params.get(:text);
        self.suffixText = params.get(:suffixText);
        self.prefixTextColor = params.get(:prefixTextColor);
        self.textColor = params.get(:textColor);
        self.suffixTextColor = params.get(:suffixTextColor);
        self.font = params.get(:font);
    }
}
