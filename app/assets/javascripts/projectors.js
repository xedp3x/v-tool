var cach = new Array();
var slide = 0;
var projector = 0;
var myip = '';
var hasTimer = true;

function slide_load(id) {
	try {
		slide = id;
		if (cach["slide-" + id] == undefined) {
			$.get('/slides/' + id + '.text', function(data) {
				$('#body').html(data);
				cach["slide-" + id] = data;
				$('#body').css('top', 110);
			});
		} else {
			$('#body').html(cach["slide-" + id]);
			$('#body').css('top', 110);
		}
	} catch(err) {
		$('.flash-danger').html('<center>ERROR: slide_load</center><br /><br /><pre style="font-size: 25%;">' + err.message + '</pre>').fadeIn('slow').delay(15000).fadeOut('slow');
	}
}

function projector_cmd(data) {
	try {
		switch (data["cmd"]) {
			case "load":
				slide_load(data["slide"]);
				break;
			case "reload":
				location.reload();
				break;
			case "ident":
				$('.flash-information').html('<center>Beamer <span style="font-size: 400%;">' + projector + '</span></center>').fadeIn('slow').delay(5000).fadeOut('slow');
				break;
			case "flash":
				if (data["name"] == undefined) {
					$('.flash-danger').fadeOut('slow');
					$('.flash-information').fadeOut('slow');
					$('.flash-success').fadeOut('slow');
				} else {
					$('.flash-' + data["name"]).html(data["text"]).fadeIn('slow');
					if (data["time"] != 0) {
						$('.flash-' + data["name"]).delay(data["time"] * 1000).fadeOut('slow');
					}
				}
				break;
			case "zoom-in":
				$('#body').css('font-size', parseFloat($('#body').css('font-size'), 10) * 1.2);
				break;
			case "zoom-out":
				$('#body').css('font-size', parseFloat($('#body').css('font-size'), 10) * 0.8);
				break;
			case "zoom-reset":
				$('#body').css('font-size', 13);
				break;
			case "scroll-up":
				$('#body').animate({
					top : "-=100px",
				}, 1000);
				break;
			case "scroll-down":
				$('#body').animate({
					top : "+=100px",
				}, 1000);
				break;
			case "scroll-null":
				$('#body').animate({
					top : 110,
				}, 1000);
				break;
			default:
				$('.flash-danger').html('<center>ERROR: Unknown command.</center><br /><br /><pre style="font-size: 25%;">Data: ' + print_r(data) + '</pre>').fadeIn('slow').delay(15000).fadeOut('slow');
				break;
		}
	} catch(err) {
		$('.flash-danger').html('<center>ERROR: projector_cmd</center><br /><br /><pre style="font-size: 25%;">' + err.message + '</pre>').fadeIn('slow').delay(15000).fadeOut('slow');

	}
}

function projector_init() {
	try {
		push.subscribe("command", function(data) {
			if (data["id"] == 'projector-' + projector || data["id"] == "projector") {
				projector_cmd(data);
			}
		});

		push.subscribe("data", function(data) {
			cach[data["id"]] = data["data"];
			if (data["id"] == 'slide-' + slide) {
				$('#body').html(data["data"]);
			}
		});

		push.subscribe("clock", function(data) {
			try {
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
						$('#currentTime').html(hours + ':' + minutes);
					} else {
						if (hasTimer) {
							if (document.getElementById('timer-' + c["id"]) == undefined) {
								document.getElementById('timers').innerHTML += '<div id="timer-' + c["id"] + '" class="timer" > --:-- </div>'
							}
						}
						if (c["unix"] < 0) {
							$('#timer-' + c["id"]).html('⌛  -' + minutes + ':' + seconds).css('background-color', '#' + c["color"]).css('color', '#000000');
						} else {
							$('#timer-' + c["id"]).html('⌛ ' + minutes + ':' + seconds).css('background-color', '#' + c["color"]).css('color', '#FFFFFF');
						}

						if (c["visable"]) {
							$('#timer-' + c["id"]).show();
						} else {
							$('#timer-' + c["id"]).hide();
						}
					}
				}
			} catch(err) {
				$('.flash-danger').html('<center>ERROR: projector_cmd</center><br /><br /><pre style="font-size: 25%;">' + err.message + '</pre>').fadeIn('slow').delay(15000).fadeOut('slow');

			}
		});

		slide_load(slide);

	} catch(err) {
		$('.flash-danger').html('<center>ERROR: projector_init</center><br /><br /><pre style="font-size: 25%;">' + err.message + '</pre>').fadeIn('slow').delay(15000).fadeOut('slow');

	}
}

function ShowFlashMenu() {
	if ($('#flash-data').is(':hidden')) {
		$('#flash-data').show();
		var el = $('#flash');
		autoHeight = el.css('height', 'auto').height();
		$('#flash-data').hide();
		el.height(0).animate({
			height : autoHeight
		}, 500, function() {
			$('#flash-data').fadeIn('fast');
		});
	} else {
		$('#flash-data').fadeOut('fast');
		$('#flash').animate({
			height : 0
		}, 500);
	}
}
