using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;

class BabyManualPickerDelegate extends WatchUi.NumberPickerDelegate {
	var arr;
	function initialize(a) {
		NumberPickerDelegate.initialize();
		arr = a;
	}
	function onNumberPicked(val) {
		System.println(arr);
		var t = Time.today().add(val);
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
		//array.add(t.value());
		Application.Storage.setValue(arr, newArray);
		WatchUi.requestUpdate();
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
}