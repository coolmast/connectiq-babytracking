using Toybox.WatchUi;

enum {
	FPD,
	TV
}

class StatsBehaviorDelegate extends WatchUi.BehaviorDelegate {
	var mode = FPD;
	function initialize() {
		BehaviorDelegate.initialize();
	}
	
	function onPreviousPage() {
		switch (mode) {
			case FPD:
				mode = TV;
				WatchUi.switchToView(new FeedsTimelineView(), self, WatchUi.SLIDE_IMMEDIATE);
				break;
			case TV:
				mode = FPD;
				WatchUi.switchToView(new FeedsPerDayView(), self, WatchUi.SLIDE_IMMEDIATE);
				break;
		}
		return true;
	}
	
	function onNextPage() {
		switch (mode) {
			case FPD:
				mode = TV;
				WatchUi.switchToView(new FeedsTimelineView(), self, WatchUi.SLIDE_IMMEDIATE);
				break;
			case TV:
				mode = FPD;
				WatchUi.switchToView(new FeedsPerDayView(), self, WatchUi.SLIDE_IMMEDIATE);
				break;
		}
		return true;
	}
}