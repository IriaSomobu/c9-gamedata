extends Spatial

var corescript;
var got_nerror = false;

func _ready():	
	corescript = load("res://front_script.gdns").new()
	corescript.set_error_listener(self);
#	corescript.initialize();
	
	if got_nerror: return;
	
	var data = corescript.get_main_data();
	print("Got data from script: ", data)
	
	goto_main(data);

func clear_contents():
	for n in get_children():
		remove_child(n)
		n.queue_free()

func goto_main(core_data):
	clear_contents();
	
	var ui = load("res://main_screen/UI.tscn").instance()
	ui.core_data(core_data)
	add_child(ui)

func on_native_error(title, message):
	got_nerror = true;
	clear_contents();
	
	var ui = load("res://error_screen/UI.tscn").instance()
	ui.set_error(title, message);
	add_child(ui)
