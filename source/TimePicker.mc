using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;
using Toybox.WatchUi;
using Toybox.Time;

const FACTORY_COUNT_24_HOUR = 3;
const FACTORY_COUNT_12_HOUR = 4;
const MINUTE_FORMAT = "%02d";

class TimePicker extends WatchUi.Picker {

    function initialize() {

        var title = new WatchUi.Text({:text=> Rez.Strings.start_time, :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});
        var factories;
        var hourFactory;
        var numberFactories;

		factories = new [FACTORY_COUNT_24_HOUR];
		factories[0] = new NumberFactory(0, 23, 1, {});

        factories[1] = new WatchUi.Text({:text=>":", :font=>Graphics.FONT_MEDIUM, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER, :color=>Graphics.COLOR_WHITE});
        factories[2] = new NumberFactory(0, 59, 1, {:format=>MINUTE_FORMAT});

		var info = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		var defaults = [0, 0, 0, 0];
		defaults[0] = factories[0].getIndex(info.hour);
		defaults[2] = factories[2].getIndex(info.min);

        Picker.initialize({:title=>title, :pattern=>factories, :defaults=>defaults});
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class TimePickerDelegate extends WatchUi.PickerDelegate {

	var arr;
    function initialize(a) {
        PickerDelegate.initialize();
        arr = a;
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
    	System.println(values);
        System.println(arr);
		var t = Time.today().add(new Time.Duration((values[0]*60+values[2])*60));
		var cur = Time.now();
		if (cur.lessThan(t)) {
			t = t.subtract(new Time.Duration(Time.Gregorian.SECONDS_PER_DAY));
		}
		var info = Time.Gregorian.info(t, Time.FORMAT_LONG);
		System.println(Lang.format("$1$ $2$:$3$", [
			info.day_of_week,
			info.hour.format("%02d"),
			info.min.format("%02d")
		]));
		var array = Application.Storage.getValue(arr);
		if (array == null) {
			array = [];
		}
		var newArray = [];
		var val = t.value();
		var added = false;
		for (var i=0; i<array.size(); i++) {
			if (array[i] < val) {
				newArray.add(array[i]);
			} else {
				if (!added) {
					newArray.add(val);
					added = true;
				}
				newArray.add(array[i]);
			}
		}
		if (!added) {
			newArray.add(val);
		}
		Application.Storage.setValue(arr, newArray);
		WatchUi.requestUpdate();
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}
