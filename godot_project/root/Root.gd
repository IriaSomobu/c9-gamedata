extends Spatial

var core;
var got_nerror = false; # We got error report from natives

func _ready():
	core = load("res://front_script.gdns").new()
	core.set_error_listener(self);
	core.initialize();
	if got_nerror: return;
	
	setup_window_from_options();
	
	goto_main();

func setup_window_from_options():
	var fullscreen = core.get_option("GD_FULLSCREEN") == "true"
	
	OS.set_window_fullscreen(fullscreen)
	
	if not fullscreen:
		var ws = core.get_option("GD_RESOLUTION").split("x") as PoolStringArray
		OS.window_size = Vector2(ws[0], ws[1])
		OS.window_borderless = core.get_option("GD_BORDERLESS") == "true";
		
		var scr_size = OS.get_screen_size(OS.current_screen)
		var win_size = OS.get_window_size()
#		OS.set_window_position(scr_size*0.5 - win_size*0.5)
	


func clear_contents():
	for n in get_children():
		remove_child(n)
		n.queue_free()

func goto_main():
	clear_contents();
	
	var ui = load("res://main_screen/UI.tscn").instance()
	add_child(ui)

func goto_newchar(mode):
	clear_contents();
	
	var ui = load("res://newgame_screen/NewgameUI.tscn").instance()
	add_child(ui)
	ui.set_mode(mode);

func goto_loading():
	clear_contents();
	
	var ui = load("res://loading_screen/LoadingUI.tscn").instance()
	add_child(ui)

func on_native_debug(message):
	print(message)

func on_native_error(title, message):
	got_nerror = true;
	clear_contents();
	
	var ui = load("res://error_screen/UI.tscn").instance()
	ui.set_error(title, message);
	add_child(ui)

func on_settings_applied():
	setup_window_from_options();
