// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .


function print_r(arr, level) {
	var dumped_text = "";
	if (!level) level = 0;
 
	//The padding given at the beginning of the line.
	var level_padding = "";
	var bracket_level_padding = "";
 
	for (var j = 0; j < level + 1; j++) level_padding += "    ";
	for (var b = 0; b < level; b++) bracket_level_padding += "    ";
 
	if (typeof(arr) == 'object') { //Array/Hashes/Objects 
		dumped_text += "Array\n";
		dumped_text += bracket_level_padding + "(\n";
		for (var item in arr) {
 
			var value = arr[item];
 
			if (typeof(value) == 'object') { //If it is an array,
				dumped_text += level_padding + "[" + item + "] => ";
				dumped_text += print_r(value, level + 2);
			} else {
				dumped_text += level_padding + "[" + item + "] => " + value + "\n";
			}
 
		}
		dumped_text += bracket_level_padding + ")\n\n";
	} else { //Stings/Chars/Numbers etc.
		dumped_text = "===>" + arr + "<===(" + typeof(arr) + ")";
	}
	return dumped_text;
}

function CheckVerbindung(){
	if (document.getElementById("menu-state").innerHTML== "Verbinde . . . "){
		alert('Es konnte keine Live-Verbindung Aufgebaut werden :-(');
	}	
}
