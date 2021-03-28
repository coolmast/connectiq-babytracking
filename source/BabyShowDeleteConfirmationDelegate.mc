using Toybox.WatchUi;
using Toybox.System;

class BabyShowDeleteConfirmationDelegate extends WatchUi.ConfirmationDelegate {
	var arr;
	var id;
	function initialize(a, i) {
		ConfirmationDelegate.initialize();
		arr = a;
		id = i;
	}
	function onResponse(resp) {
		if (resp == WatchUi.CONFIRM_NO) {
			System.println("Cancel");
		} else {
			System.println("Confirm");
			System.println("Delete: " + id + " in " + arr);
			var array = Application.Storage.getValue(arr);
			array.remove(id);
			Application.Storage.setValue(arr, array);
			WatchUi.requestUpdate();
		}
	}
}