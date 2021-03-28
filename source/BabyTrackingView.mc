using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;
using Toybox.Timer;
using Toybox.Application;
using Toybox.Background;

class BabyTrackingView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	WatchUi.requestUpdate();
    }

	function updateCallback() {
		WatchUi.requestUpdate();
	}

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        var text = View.findDrawableById("last_feed");
        var feedings = Application.Storage.getValue("feedings");
        var nT = WatchUi.loadResource(Rez.Strings.last) + "\n";
        if (feedings != null && feedings.size() > 0) {
			var lastFeeding = feedings[feedings.size()-1];
			if (lastFeeding != null) {
				var feedTime = new Time.Moment(lastFeeding);
				var info = Time.Gregorian.info(feedTime, Time.FORMAT_LONG);
				nT += WatchUi.loadResource(Rez.Strings.feeding) + ":\n" + Lang.format("$1$ $2$:$3$\n", [
					info.day_of_week,
					info.hour.format("%02d"),
					info.min.format("%02d")
				]);
        	}
        }
        var trig = Background.getTemporalEventRegisteredTime();
        if (trig != null) {
			var diff = trig.subtract(Time.now()).value();
			var hours = diff / 60 / 60;
			var mins = (diff - hours * 60 * 60) / 60;
			var secs = (diff - hours * 60 * 60 - mins * 60);
			nT += Lang.format(WatchUi.loadResource(Rez.Strings.in)+": $1$:$2$:$3$\n", [hours, mins, secs]);
        } 
        var sleepings = Application.Storage.getValue("sleepings");
        if (sleepings != null && sleepings.size() > 0) {
			var lastSleeping = sleepings[sleepings.size()-1];
			if (lastSleeping != null) {
				var sleepTime = new Time.Moment(lastSleeping);
				var info = Time.Gregorian.info(sleepTime, Time.FORMAT_LONG);
				nT += WatchUi.loadResource(Rez.Strings.sleeping) + ":\n" + Lang.format("$1$ $2$:$3$", [
					info.day_of_week,
					info.hour.format("%02d"),
					info.min.format("%02d")
				]);
			}
        }
        text.setText(nT);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
