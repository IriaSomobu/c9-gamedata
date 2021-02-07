extends Spatial

var corescript;

func _ready():	
	corescript = load("res://front_script.gdns").new()
	var data = corescript.get_main_data();
	print("Got data from script: ", data)
	
	goto_main(data);

func clear_contents():
	for n in get_children():
		remove_child(n)
		n.queue_free()

func goto_main(core_data):
	clear_contents();
	
	var ui = load("res://main_menu/UI.tscn").instance()
	ui.core_data(core_data)
	add_child(ui)
