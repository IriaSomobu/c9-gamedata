extends Control

onready var core = get_node("/root/Root").core;

var mod_item_ref = load("res://newgame_screen/ModItem.tscn")
var settings_page;
var current_mods;

func setup():
	settings_page = core.get_world_settings()[0]["options"];
	current_mods = core.list_available_mods()
	$Settings/OptionsPanel.set_data(settings_page);
	
	for mod_item_data in current_mods:
		var mod_item = mod_item_ref.instance();
		mod_item.text = mod_item_data["name"];
		mod_item.hint_tooltip = "";
		if mod_item_data["enabled"]: mod_item.pressed = true
		mod_item.connect("focus_entered", self, "on_mod_item_focused", [mod_item_data])
		mod_item.connect("toggled",       self, "on_mod_item_toggled", [mod_item_data])
		$Modlist/ScrollContainer/GridContainer.add_child(mod_item)


func on_mod_item_focused(data):
	var text = "Name: "+data["name"]
	text += "\nDependencies: "
	for dep in data["deps"]: text += dep + " "
	text += "\n[ "+core.tr("Press here to view mod info")+" ]"
	
	$Modlist/ModinfoBtn/Label.text = text;
	
	var e_text = "Name: "+data["name"] + " [ "+data["codename"]+" ]"
	e_text += "\nDescription: "+data["descr"]
	e_text += "\nSource: "+data["source"]
	e_text += "\nDependencies: "
	for dep in data["deps"]: e_text += dep + " "
	
	e_text += "\nAuthors: "
	for a in data["authors"]: e_text += a + " "
	
	$ModInfoDlg.dialog_text = e_text;


func on_mod_item_toggled(state, data):
	data["enabled"] = state
	if state:
		for dep in data["deps"]:
			for i in range(current_mods.size()):
				if current_mods[i]["codename"] == dep:
					$Modlist/ScrollContainer/GridContainer.get_child(i).pressed = true
	else:
		for i in range(current_mods.size()):
			if current_mods[i]["deps"].has(data["codename"]):
				$Modlist/ScrollContainer/GridContainer.get_child(i).pressed = false


func on_mod_info_btn():
	$ModInfoDlg.popup();


func _on_BtnBack_pressed():
	get_parent().back_to_main();


func _on_BtnConfirm_pressed():
	
	var mods = []
	for mod in current_mods:
		if mod["enabled"]:
			mods.append(mod["codename"]);
	
	if mods.size() == 0:
		$NoModsDlg.popup()
		return
	
	var options = $Settings/OptionsPanel.get_options_dict();
	
	get_parent().to_chargen(mods, options);
