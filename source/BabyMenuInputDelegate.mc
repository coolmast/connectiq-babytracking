using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Time;
using Toybox.Background;

class BabyMenuInputDelegate extends WatchUi.Menu2InputDelegate {

	function initialize() {
		Menu2InputDelegate.initialize();
	}
	
	function updateTimer() {
		//var THREE_HOURS = new Time.Duration(3 * 60 * 60);
		var THREE_HOURS = new Time.Duration(3 );
		var alertTime = Time.now().add(THREE_HOURS);
		Background.registerForTemporalEvent(alertTime);
	}
	
	function onSelect(item) {
		System.println(item.getId());
		if (item.getId().equals("feedNow")) {
			var feedings = Application.Storage.getValue("feedings");
			if (feedings == null) {
				feedings = [];
			}
			feedings.add(Time.now().value());
			Application.Storage.setValue("feedings", feedings);
			updateTimer();
			WatchUi.requestUpdate();
			WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
		} else if (item.getId().equals("feedManual")) {
			var feedPicker = new WatchUi.NumberPicker(
				WatchUi.NUMBER_PICKER_TIME_OF_DAY,
				0
			);	
			WatchUi.pushView(feedPicker,
				new BabyManualPickerDelegate("feedings"),
				WatchUi.SLIDE_IMMEDIATE);	
		} else if (item.getId().equals("sleepNow")) {
			var sleepings = Application.Storage.getValue("sleepings");
			if (sleepings == null) {
				sleepings = [];
			}
			sleepings.add(Time.now().value());
			Application.Storage.setValue("sleepings", sleepings);
			WatchUi.requestUpdate();
			WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
		} else if (item.getId().equals("showFeedings")) {
			var feedings = Application.Storage.getValue("feedings");
			if (feedings == null) {
				feedings = [];
			}
			var menu = new WatchUi.Menu2({:title => WatchUi.loadResource(Rez.Strings.Feedings)});
			for (var i=feedings.size()-1; i >= 0; i--) {
				var feed = feedings[i];
				var feedTime = new Time.Moment(feed);
				var info = Time.Gregorian.info(feedTime, Time.FORMAT_LONG);
				menu.addItem(
					new WatchUi.MenuItem(
						Lang.format("$1$:$2$", [
							info.hour.format("%02d"),
							info.min.format("%02d")]),
						Lang.format("$1$", [info.day_of_week]),
						feed,
						{}
					)
				);
			}
			WatchUi.pushView(menu, new BabyShowMenuInputDelegate("feedings"), WatchUi.SLIDE_IMMEDIATE);
		} else if (item.getId().equals("sleepManual")) {
			var sleepPicker = new WatchUi.NumberPicker(
				WatchUi.NUMBER_PICKER_TIME_OF_DAY,
				0
			);
			WatchUi.pushView(sleepPicker,
				new BabyManualPickerDelegate("sleepings"),
				WatchUi.SLIDE_IMMEDIATE);
		} else if (item.getId().equals("showSleepings")) {
			var sleepings = Application.Storage.getValue("sleepings");
			if (sleepings == null) {
				sleepings = [];
			}
			var menu = new WatchUi.Menu2({:title => WatchUi.loadResource(Rez.Strings.Sleeps)});
			for (var i=sleepings.size()-1; i >= 0; i--) {
				var sleep = sleepings[i];
				var sleepTime = new Time.Moment(sleep);
				var info = Time.Gregorian.info(sleepTime, Time.FORMAT_LONG);
				menu.addItem(
					new WatchUi.MenuItem(
						Lang.format("$1$:$2$", [
							info.hour.format("%02d"),
							info.min.format("%02d")]),
						Lang.format("$1$", [info.day_of_week]),
						sleep,
						{}
					)
				);
			}
			WatchUi.pushView(menu, new BabyShowMenuInputDelegate("sleepings"), WatchUi.SLIDE_IMMEDIATE);
		}
	}

}