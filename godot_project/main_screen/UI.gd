extends Control

onready var core = get_node("/root/Root").core;

var motd = "";
var credits = "";
var tip = "";

func core_data(data):
	tip = data["tip"]
	motd = data["motd"]
	credits = data["credits"]

func _ready():
	$AppLogo.text = core.tr("Cataclysm Nine");
	$Tips.bbcode_text = tip;
	
	$Menu/MOTD.text = core.tr("MOTD");
	$Menu/NewGame.text = core.tr("New Game");
	$Menu/Load.text = core.tr("Load");
	$Menu/World.text = core.tr("World");
	$Menu/Settings.text = core.tr("Settings");
	$Menu/Help.text = core.tr("Help");
	$Menu/Credits.text = core.tr("Credits");
	$Menu/Quit.text = core.tr("Quit");
	
	$Menu/MOTD.grab_focus()

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
			print("Loadgame")
		"world":
			print("World")
		"settings":
			print("settings")
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
