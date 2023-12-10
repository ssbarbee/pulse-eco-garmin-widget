import Toybox.Graphics;
import Toybox.WatchUi;

class skopje_pulse_ecoView extends WatchUi.View {

    function initialize() {
        View.initialize();
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

    // // Update the view
    // function onUpdate(dc as Dc) as Void {
    //     // Call the parent onUpdate function to redraw the layout
    //     View.onUpdate(dc);

    //     // Iterate through the global sensors list and display data
    //     foreach (var sensor in Eco.sensors) {
    //         // Use dc.drawText() or other methods to display sensor data
    //         // Example:
    //         // dc.drawText(sensor.id, font, x, y, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_TOP);
    //     }
    // }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
