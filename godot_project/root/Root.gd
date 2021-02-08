extends Spatial

var core;
var got_nerror = false; # We got error report from natives

func _ready():	
	core = load("res://front_script.gdns").new()
	core.set_error_listener(self);
	core.initialize();
	if got_nerror: return;
	
	var v = "Version: %s";
	print("Translation of [", v, "]: ", core.tr(v))
	
	var data = core.get_main_data();
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
