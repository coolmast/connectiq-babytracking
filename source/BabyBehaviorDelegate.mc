using Toybox.WatchUi;

class BabyBehaviorDelegate extends WatchUi.BehaviorDelegate {
	function initialize() {
		BehaviorDelegate.initialize();
	}
	
	function onMenu() {
		var menu = new WatchUi.Menu2({:title => "BabyTracking"});
		var delegate;
		
		menu.addItem(
			new WatchUi.MenuItem(
				WatchUi.loadResource(Rez.Strings.Feeding),
				WatchUi.loadResource(Rez.Strings.start_now),
				"feedNow",
				{}
			)
		);
		menu.addItem(
			new WatchUi.MenuItem(
				WatchUi.loadResource(Rez.Strings.Feeding),
				WatchUi.loadResource(Rez.Strings.manual),
				"feedManual",
				{}
			)
		);
		menu.addItem(
			new WatchUi.MenuItem(
				WatchUi.loadResource(Rez.Strings.Feeding),
				WatchUi.loadResource(Rez.Strings.show),
				"showFeedings",
				{}
			)
		);
		menu.addItem(
			new WatchUi.MenuItem(
				WatchUi.loadResource(Rez.Strings.Sleeping),
				WatchUi.loadResource(Rez.Strings.start_now),
				"sleepNow",
				{}
			)
		);
		menu.addItem(
			new WatchUi.MenuItem(
				WatchUi.loadResource(Rez.Strings.Sleeping),
				WatchUi.loadResource(Rez.Strings.manual),
				"sleepManual",
				{}
			)
		);
		menu.addItem(
			new WatchUi.MenuItem(
				WatchUi.loadResource(Rez.Strings.Sleeping),
				WatchUi.loadResource(Rez.Strings.show),
				"showSleepings",
				{}
			)
		);
		
		delegate = new BabyMenuInputDelegate();
		
		WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
		return true;
	}
	
}