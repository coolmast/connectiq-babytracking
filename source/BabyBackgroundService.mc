using Toybox.System;

(:background)
class BabyBackgroundService extends System.ServiceDelegate {
	function initialize() {
		ServiceDelegate.initialize();
	}
	function onTemporalEvent() {
		System.println("notify");
		Background.requestApplicationWake("Time to feed!");
		Background.exit(null);
	}
}