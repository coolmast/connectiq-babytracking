using Toybox.WatchUi;
using Toybox.Time;

class FeedsTimelineView extends WatchUi.View {
	function initialize() {
		View.initialize();
	}
	
	function onLayout(dc) {
		setLayout(Rez.Layouts.FeedsTimelineLayout(dc));
	}
	
	function onShow() {
		WatchUi.requestUpdate();
	}
	
	function onUpdate(dc) {
		View.onUpdate(dc);
		var feedings = Application.Storage.getValue("feedings");
		if (feedings == null) {
			dc.drawText(dc.getWidth()/2,
				dc.getHeight()/2,
				WatchUi.loadResource(Rez.Strings.no_data),
				Graphics.FONT_MEDIUM,
				(Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
			return;
		}
		var feedTimes = [[], [], [], [], [], [], []];
		var feedIt = feedings.size()-1;
		for (var i=6; i>=0; i--) {
			var dayOffset = 6-i;
			var t = Time.today().subtract(new Time.Duration(dayOffset*Time.Gregorian.SECONDS_PER_DAY));
			for (; feedIt>=0; feedIt--) {
				var feedMoment = new Time.Moment(feedings[feedIt]);
				if (feedMoment.greaterThan(t)) {
					var feedInfo = Time.Gregorian.info(feedMoment, Time.FORMAT_SHORT);
					var at = (feedInfo.hour*60+feedInfo.min).toFloat() / (24*60);
					feedTimes[i].add(at);
				} else {
					break;
				}
			}
		}
		System.println(feedTimes);
		if (dc has :setAntiAlias) {
			dc.setAntiAlias(true);
		}
		var sW = dc.getWidth();
		var sH = dc.getHeight();
		for (var i=0; i<7; i++) {
			var x = sW * 0.3;
			var y = sH * 0.2 + i * 0.1 * sH;
			var rW = 0.6 * sW;
			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
			dc.drawLine(x, y, x+rW, y);
			dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
			dc.setPenWidth(3);
			for (var feeds=0; feeds<feedTimes[6-i].size(); feeds++) {
				var atX = x + rW * feedTimes[6-i][feeds];
				dc.drawLine(atX, y-7, atX, y+7);
			}
			dc.setPenWidth(1);
			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
			var dayOffset = i;
			var t = Time.today().subtract(new Time.Duration(dayOffset*Time.Gregorian.SECONDS_PER_DAY));
			var info = Time.Gregorian.info(t, Time.FORMAT_LONG);
			dc.drawText(0.2*sW, y,
				Graphics.FONT_TINY,
				info.day_of_week,
				(Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
		}
	}
	
	function onHide() {
	}
}