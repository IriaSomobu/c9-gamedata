extends ScrollContainer

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
		
		option.connect("focus_entered", self, "_on_focus_change")
		option.connect("option_changed", self, "on_option_changed");
		$OptionsList.add_child(option);


func _on_focus_change():
	var focused = get_focus_owner()
	var focus_offset = focused.rect_position.y
	var focus_offset_bottom = focus_offset + focused.get_size().y;
	
	var scrolled_top = get_v_scroll()
	var scrolled_bottom = scrolled_top + get_size().y - focused.get_size().y
	
	if focus_offset < scrolled_top:
		set_v_scroll(focus_offset)
	
	if focus_offset_bottom >= scrolled_bottom:
		var t = focus_offset_bottom - scrolled_bottom;
		set_v_scroll(get_v_scroll() + t)

func on_option_changed(name, value):
	emit_signal("option_changed", name, value)

func get_options_dict():
	var result = {}
	
	for option in $OptionsList.get_children():
		result[option.code] = option.current_value
	
	return result
