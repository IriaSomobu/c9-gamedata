extends Control

onready var core = get_node("/root/Root").core;

var motd = "";
var credits = "";
var tip = "";

func _ready():
	get_node("/root/Root").connect("settings_changed", self, "reload_data");
	reload_data();
	$Menu/MOTD.grab_focus()

func reload_data():
	var data = core.get_main_data();
	tip = data["tip"]
	motd = data["motd"]
	credits = data["credits"]
	
	$AppLogo.text = core.tr("Cataclysm Nine");
	$Tips.bbcode_text = tip;
	
	$Menu/MOTD.text = core.tr("MOTD");
	$Menu/NewGame.text = core.tr("New Game");
	$Menu/Load.text = core.tr("Saves");
	$Menu/Settings.text = core.tr("Settings");
	$Menu/Help.text = core.tr("Help");
	$Menu/Credits.text = core.tr("Credits");
	$Menu/Quit.text = core.tr("Quit");

func hide_all_panels():
	for n in $PanelContainer.get_children():
		n.visible = false


func switch_panel(name):
	hide_all_panels();
	
	match name:
		"motd":
			show_panel_text(motd)
		"newgame":
			$PanelContainer/PanelNewgame.visible = true
		"loadgame":
			$PanelContainer/PanelLoadgame.visible = true
		"settings":
			$PanelContainer/Settings.visible = true
		"help":
			$PanelContainer/Help.visible = true
		"credits":
			show_panel_text(credits)



func show_panel_text(data):
	$PanelContainer/PanelText.visible = true
	$PanelContainer/PanelText/PanelText.bbcode_text = "\n"+data;



func _on_Quit_button_up():
	# TODO: stop natives
	get_tree().quit()
