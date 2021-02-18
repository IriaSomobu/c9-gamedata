extends Control

onready var core = get_node("/root/Root").core;
var mod_item_ref = load("res://newgame_screen/ModItem.tscn")
var settings_page;
var current_mods;

func set_mode(mode):
	settings_page = core.get_world_settings()[0]["options"];
	current_mods = core.list_available_mods()
	$Worldgen/Settings/OptionsPanel.set_data(settings_page);
	
	for mod_item_data in current_mods:
		var mod_item = mod_item_ref.instance();
		mod_item.text = mod_item_data["name"];
		mod_item.hint_tooltip = "";
		if mod_item_data["enabled"]: mod_item.pressed = true
		mod_item.connect("focus_entered", self, "on_mod_item_focused", [mod_item_data])
		$Worldgen/Modlist/ScrollContainer/GridContainer.add_child(mod_item)
	
	setup_world_panel();


func setup_world_panel():
	$Worldgen.visible = true
	$Chargen.visible = false
	$Worldgen/Modlist/ScrollContainer/GridContainer.get_child(0).grab_focus()

func on_mod_item_focused(data):
	var text = "Name: "+data["name"]
	text += "\nDependencies: "
	for dep in data["deps"]: text += dep + " "
	text += "\n[ "+core.tr("Press here to view mod info")+" ]"
	
	$Worldgen/Modlist/ModinfoBtn/Label.text = text;
	
	var e_text = "Name: "+data["name"] + " [ "+data["codename"]+" ]"
	e_text += "\nDescription: "+data["descr"]
	e_text += "\nSource: "+data["source"]
	e_text += "\nDependencies: "
	for dep in data["deps"]: e_text += dep + " "
	
	e_text += "\nAuthors: "
	for a in data["authors"]: e_text += a + " "
	
	$Worldgen/ModInfoDlg.dialog_text = e_text;

func on_mod_info_btn():
	$Worldgen/ModInfoDlg.popup();

func back_to_main():
	get_node("/root/Root").goto_main()

func to_chargen():
	
	
	core.create_tmp_world({
		"options": {},
		"mods": []
	});
	
	$Worldgen.visible = false
	$Chargen.visible = true

func back_to_mapgen():
	setup_world_panel();

func confirm():
	pass

