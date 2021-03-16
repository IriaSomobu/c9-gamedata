extends FocusableScrollContainer

signal option_changed(codename, value)

var option_scene = load("res://reusabe_menus/settings/Option.tscn");

func set_data(page):
	for n in $OptionsList.get_children():
		$OptionsList.remove_child(n)
	
	for o in page:
		var option = option_scene.instance();
		option.name = o["code"];
		option.code = o["code"];
		option.title = o["name"]; 
		option.descr = o["desc"];
		option.hint_tooltip = o["desc"];
		
		match o["mode"]:
			"empty":
				option.be_empty()
			"num":
				option.be_number(o["min"], o["max"] + 1, o["step"])
			"vals":
				option.values = o["values"]
			"str":
				option.be_string()
		
		option.current_value = o["value"];
		
		option.connect("option_changed", self, "on_option_changed");
		$OptionsList.add_child(option);
		make_scrollable(option)


func on_option_changed(name, value):
	emit_signal("option_changed", name, value)

func get_options_dict():
	var result = {}
	
	for option in $OptionsList.get_children():
		result[option.code] = option.current_value
	
	return result
