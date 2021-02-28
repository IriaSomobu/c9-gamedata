extends Panel

onready var core = get_node("/root/Root").core;
var pages = [];

func _ready():
	reload_data();
	get_node("/root/Root").connect("settings_changed", self, "reload_data");


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


func _on_tab_changed(tab):
	$OptionsPanel.set_data(pages[tab]["options"]);


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
