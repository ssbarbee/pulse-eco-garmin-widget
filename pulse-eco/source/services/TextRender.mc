import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

function renderText(
    params as
        {
            :dc as Dc,
            :prefixText as String?,
            :text as String?,
            :suffixText as String?,
            :prefixTextColor as Number?,
            :textColor as Number?,
            :suffixTextColor as Number?,
            :font as Number?,
            :x as Number?,
            :y as Number?,
        }
) {
    var dc = params.get(:dc);
    var x = params.get(:x) != null ? params.get(:x) : dc.getWidth() / 2;
    var y = params.get(:y) != null ? params.get(:y) : dc.getHeight() / 2;
    var font = params.get(:font) != null ? params.get(:font) : Graphics.FONT_TINY;

    var prefixText = params.get(:prefixText) != null ? params.get(:prefixText) : "";
    var text = params.get(:text) != null ? params.get(:text) : "";
    var suffixText = params.get(:suffixText) != null ? params.get(:suffixText) : "";

    var prefixTextColor =
        params.get(:prefixTextColor) != null ? params.get(:prefixTextColor) : Graphics.COLOR_WHITE;
    var textColor = params.get(:textColor) != null ? params.get(:textColor) : Graphics.COLOR_WHITE;
    var suffixTextColor = params.get(:suffixTextColor)
        ? params.get(:suffixTextColor)
        : Graphics.COLOR_WHITE;

    var prefixTextWidth = dc.getTextWidthInPixels(prefixText, font);
    var textWidth = dc.getTextWidthInPixels(text, font);

    if (prefixText.length() > 0 and text.length() > 0 and suffixText.length() > 0) {
        dc.setColor(prefixTextColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - prefixTextWidth, y, font, prefixText, Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(suffixTextColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + textWidth, y, font, suffixText, Graphics.TEXT_JUSTIFY_LEFT);
    }

    if (prefixText.length() == 0 and text.length() > 0 and suffixText.length() == 0) {
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, text, Graphics.TEXT_JUSTIFY_CENTER);
    }

    if (prefixText.length() == 0 and text.length() > 0 and suffixText.length() > 0) {
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x - textWidth, y, font, text, Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(suffixTextColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, font, suffixText, Graphics.TEXT_JUSTIFY_LEFT);
    }
}
