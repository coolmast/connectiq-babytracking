using Toybox.WatchUi;

class BabyShowMenuInputDelegate extends WatchUi.Menu2InputDelegate {
	var arr;
	function initialize(a) {
		Menu2InputDelegate.initialize();
		arr = a;
	}
	function onSelect(item) {
		var message = WatchUi.loadResource(Rez.Strings.really_delete);
		var dialog = new WatchUi.Confirmation(message);
		WatchUi.pushView(
			dialog,
			new BabyShowDeleteConfirmationDelegate(arr, item.getId()),
			WatchUi.SLIDE_IMMEDIATE
		);
	}
}