extends Control

var description = "";

func set_data(name, descr, cost):
	if descr.length() > 96: descr = descr.substr(0, 96) + "..."
	description = descr;
	
	$Label.text = name;
	$".".hint_tooltip = descr


func set_state(enabled):
	pass
