extends Panel

onready var core = get_node("/root/Root").core;
var pages = [];

var option_scene = load("res://reusabe_menus/settings/Option.tscn");

func _ready():
	reload_data();


func reload_data():
	pages = core.get_settings();
	
	var current_tab = $Tabs.current_tab
	
	while $Tabs.get_tab_count() > 0:
		$Tabs.remove_tab(0)
	
	for page in pages:
		$Tabs.add_tab(page["name"])
	
	$BtnSave.visible = false
	$BtnRestore.visible = false
	
	$Tabs.current_tab = current_tab
	_on_tab_changed(current_tab);


func _on_focus_change():
	var focused = get_focus_owner()
	var focus_offset = focused.rect_position.y
	var focus_offset_bottom = focus_offset + focused.get_size().y;
	
	var scrolled_top = $ScrollContainer.get_v_scroll()
	var scrolled_bottom = scrolled_top + $ScrollContainer.get_size().y - focused.get_size().y
	
	if focus_offset < scrolled_top:
		$ScrollContainer.set_v_scroll(focus_offset)
	
	if focus_offset_bottom >= scrolled_bottom:
		var t = focus_offset_bottom - scrolled_bottom;
		$ScrollContainer.set_v_scroll($ScrollContainer.get_v_scroll() + t)


func _on_tab_changed(tab):
	for n in $ScrollContainer/OptionsList.get_children():
		$ScrollContainer/OptionsList.remove_child(n)
	
	var is_first = true
	for o in pages[tab]["options"]:
		var option = option_scene.instance();
		option.name = o["code"];
		option.code = o["code"];
		option.title = o["name"]; 
		
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
		$ScrollContainer/OptionsList.add_child(option);
		
		if is_first:
			option.focus_neighbour_top = $Tabs.get_path()
			is_first = false


func on_option_changed(name, value):
	core.set_option(name, value);
	$BtnSave.visible = true
	$BtnRestore.visible = true
	
	for o in pages[$Tabs.current_tab]["options"]:
		if o["code"] == name:
			o["value"] = value;
			break;


func _on_save_pressed():
	core.save_settings();
	$BtnSave.visible = false
	$BtnRestore.visible = false
	get_node("/root/Root").on_settings_applied();


func _on_restore_pressed():
	core.restore_settings();
	reload_data()
