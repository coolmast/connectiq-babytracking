using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Graphics;
using Toybox.Application;

class FeedsPerDayView extends WatchUi.View {
	function initialize() {
		View.initialize();
	}
	
	function onLayout(dc) {
		setLayout(Rez.Layouts.FeedsPerDayLayout(dc));
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
		var feedTimes = [0, 0, 0, 0, 0, 0, 0];
		var feedIt = feedings.size()-1;
		for (var i=6; i>=0; i--) {
			var dayOffset = 6-i;
			var t = Time.today().subtract(new Time.Duration(dayOffset*Time.Gregorian.SECONDS_PER_DAY));
			for (; feedIt>=0; feedIt--) {
				var feedMoment = new Time.Moment(feedings[feedIt]);
				if (feedMoment.greaterThan(t)) {
					feedTimes[i]++;
				} else {
					break;
				}
			}
		}
		var max = 0;
		for (var i=0; i<7; i++) {
			if (feedTimes[i] > max) {
				max = feedTimes[i];
			}
		}
		System.println(feedTimes);
		if (feedings != null) {
		}
		if (dc has :setAntiAlias) {
			dc.setAntiAlias(true);
		}
		var sW = dc.getWidth();
		var sH = dc.getHeight();
		for (var i=0; i<7; i++) {
			var x = sW * 0.08 + i * 0.12 * sW;
			var y = sH * 0.2;
			var rW = sW * 0.09;
			var rH = 0.5 * sH;
			dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);
			dc.fillRoundedRectangle(x, y+(max-feedTimes[i])*rH/max, rW, feedTimes[i]*rH/max, 10);
			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
			dc.drawRoundedRectangle(x, y, rW, rH, 10);
			dc.drawText(x+rW/2, y+rH/2,
				Graphics.FONT_SMALL,
				Lang.format("$1$", [feedTimes[i]]),
				(Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
			var dayOffset = 6-i;
			var t = Time.today().subtract(new Time.Duration(dayOffset*Time.Gregorian.SECONDS_PER_DAY));
			var info = Time.Gregorian.info(t, Time.FORMAT_LONG);
			dc.drawText(x + rW / 2, sH * 0.7, Graphics.FONT_TINY, info.day_of_week, Graphics.TEXT_JUSTIFY_CENTER);
		}
	}
	
	function onHide() {
	}
}