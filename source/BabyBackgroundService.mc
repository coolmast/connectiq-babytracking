using Toybox.System;
using Toybox.Application;

(:background)
class BabyBackgroundService extends System.ServiceDelegate {
	function initialize() {
		ServiceDelegate.initialize();
	}
	function onTemporalEvent() {
		System.println("notify");
		Background.requestApplicationWake(Application.loadResource(Rez.Strings.time_to_feed));
		Background.exit(null);
	}
}