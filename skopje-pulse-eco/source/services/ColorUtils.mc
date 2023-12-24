import Toybox.Lang;
import Toybox.Math;

function getPollutionColorValue(value as Number) {
    // Define color 'constants'
    var DARK_GREEN = [0x00, 0x64, 0x00];
    var GREEN = [0x00, 0x80, 0x00];
    var ORANGE = [0xFF, 0xA5, 0x00];
    var RED = [0xFF, 0x00, 0x00];
    var DARK_RED = [0x8B, 0x00, 0x00];

    // Define gradient segments
    var SEGMENTS = [
        {:start => 0,  :end => 19,  :startColor => DARK_GREEN, :endColor => GREEN},
        {:start => 19, :end => 35,  :startColor => GREEN, :endColor => ORANGE},
        {:start => 35, :end => 68,  :startColor => ORANGE, :endColor => RED},
        {:start => 68, :end => 100, :startColor => RED, :endColor => DARK_RED}
    ];

    return getColorValue(SEGMENTS, 0, 200, value);
}

function getTemperatureColorValue(value as Number) {
    // Define new color 'constants'
    var DARK_BLUE = [0x00, 0x00, 0x8B];
    var BLUE = [0x00, 0x00, 0xFF];
    var DARK_GREEN = [0x00, 0x64, 0x00];
    var GREEN = [0x00, 0x80, 0x00];
    var ORANGE = [0xFF, 0xA5, 0x00];
    var RED = [0xFF, 0x00, 0x00];
    var DARK_RED = [0x8B, 0x00, 0x00];

    // Update gradient segments
    var SEGMENTS = [
        {:start => 0,  :end => 38,  :startColor => DARK_BLUE, :endColor => BLUE},
        {:start => 38, :end => 52,  :startColor => BLUE, :endColor => DARK_GREEN},
        {:start => 52, :end => 65,  :startColor => DARK_GREEN, :endColor => GREEN},
        {:start => 65, :end => 77,  :startColor => GREEN, :endColor => ORANGE},
        {:start => 77, :end => 88,  :startColor => ORANGE, :endColor => RED},
        {:start => 88, :end => 100,  :startColor => RED, :endColor => DARK_RED}
    ];
    // range is -20, 40... doing some offsetting to adjust
    // basically -20 => 0
    // basically +40 => 60
    return getColorValue(SEGMENTS, 0, 60, value + 20);
}

function getColorValue(segments as Array<{ 
            :start as Number, 
            :end as Number, 
            :startColor as Array<Number>, 
            :endColor as Array<Number>
    }>, minValue as Number, maxValue as Number, value as Number) {
    var percent = ((value > maxValue ? maxValue : value < minValue ? minValue : value) / maxValue.toFloat()) * 100;
    var r = 0, g = 0, b = 0;

    for (var i = 0; i < segments.size(); i++) {
        var segment = segments[i];
        var end = segment.get(:end);
        var start = segment.get(:start);
        var startColor = segment.get(:startColor);
        var endColor = segment.get(:endColor);
        if (percent <= end) {
            var factor = (percent - start) / (end - start);
            r = interpolate(startColor[0], endColor[0], factor);
            g = interpolate(startColor[1], endColor[1], factor);
            b = interpolate(startColor[2], endColor[2], factor);

            // Ensure r, g, b are integers
            r = r.toNumber();
            g = g.toNumber();
            b = b.toNumber();
            break;
        }
    }
    // Combine RGB into hex
    return (r << 16) + (g << 8) + b; 
}

function interpolate(startValue, endValue, factor) {
    return startValue + Math.round((endValue - startValue) * factor);
}
