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

    //! Set the position
    //! @param info Position information
    public function updateView(viewModel as ViewModel) as Void {
        // _lines = [] as Array<String>;

        // var position = info.position;
        // if (position != null) {
        //     _lines.add("lat = " + position.toDegrees()[0].toString());
        //     _lines.add("lon = " + position.toDegrees()[1].toString());
        // }

        // var speed = info.speed;
        // if (speed != null) {
        //     _lines.add("speed = " + speed.toString());
        // }

        // var altitude = info.altitude;
        // if (altitude != null) {
        //     _lines.add("alt = " + altitude.toString());
        // }

        // var heading = info.heading;
        // if (heading != null) {
        //     _lines.add("heading = " + heading.toString());
        // }

        WatchUi.requestUpdate();
    }
}
