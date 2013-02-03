function timer_index_init() {

	push.subscribe("clock", function(data) {
		for (var i = 0; ( c = data[i]) != null; i++) {
			if (c["unix"] < 0) {
				var date = new Date((0 - c["unix"]) * 1000);
			} else {
				var date = new Date(c["unix"] * 1000);
			}

			var hours = date.getHours();
			if (hours < 10) {
				hours = "0" + hours
			}
			var minutes = date.getMinutes();
			if (minutes < 10) {
				minutes = "0" + minutes
			}
			var seconds = date.getSeconds();
			if (seconds < 10) {
				seconds = "0" + seconds
			}

			if (c["id"] == "main") {
				$('#time').html(hours + ':' + minutes);
			} else {
				if (document.getElementById('timer-' + c["id"] + '-now') == undefined) {
					alert('Die Seite muss neu geladen werden.');
					location.reload();
					break;
				}
				if (c["unix"] < 0) {
					$('#timer-' + c["id"] + '-now').html(minutes + ':' + seconds).css('color', '#f00');
				} else {
					$('#timer-' + c["id"] + '-now').html(minutes + ':' + seconds).css('color', '#000');
				}

				if (c["visable"]) {
					$('#timer-' + c["id"] + '-show').addClass('disabled');
					$('#timer-' + c["id"] + '-hide').removeClass('disabled');
				} else {
					$('#timer-' + c["id"] + '-show').removeClass('disabled');
					$('#timer-' + c["id"] + '-hide').addClass('disabled');
				}

				if (c["activ"]) {
					$('#timer-' + c["id"] + '-start').addClass('disabled');
					$('#timer-' + c["id"] + '-stop').removeClass('disabled');
				} else {
					$('#timer-' + c["id"] + '-start').removeClass('disabled');
					$('#timer-' + c["id"] + '-stop').addClass('disabled');
				}

				if (c["activ"] && c["visable"]) {
					$('#timer-' + c["id"] + '-start_show').addClass('disabled');
					$('#timer-' + c["id"] + '-stop_hide').removeClass('disabled');
				} else {
					if (!(c["activ"] || c["visable"])) {
						$('#timer-' + c["id"] + '-start_show').removeClass('disabled');
						$('#timer-' + c["id"] + '-stop_hide').addClass('disabled');
					} else {
						$('#timer-' + c["id"] + '-start_show').removeClass('disabled');
						$('#timer-' + c["id"] + '-stop_hide').removeClass('disabled');
					}
				}
			}
		}
	});

}