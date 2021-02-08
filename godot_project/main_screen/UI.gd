extends Control

func core_data(data):
	$AppLogo.text = data["logo"]["name"]
	$Menu/MOTD.text = data["motd"]["name"]
	$Menu/NewGame.text = data["ng"]["name"]
	$Menu/Load.text = data["lg"]["name"]
	$Menu/World.text = data["world"]["name"]
	$Menu/Settings.text = data["sets"]["name"]
	$Menu/Help.text = data["help"]["name"]
	$Menu/Credits.text = data["titles"]["name"]
	$Menu/Quit.text = data["exit"]["name"]
	$Tips.bbcode_text = data["tips"]["tip"]

func _ready():
	$Menu/MOTD.grab_focus()

func hide_all_panels():
	for n in $PanelContainer.get_children():
		n.visible = false


func switch_panel(name):
	hide_all_panels();
	
	match name:
		"motd":
			show_panel_text("Motd here")
		"newgame":
			$PanelContainer/PanelNewgame.visible = true
		"loadgame":
			print("Loadgame")
		"world":
			print("World")
		"settings":
			print("settings")
		"help":
			print("help")
		"credits":
			show_panel_text("Credits here!")



func show_panel_text(data):
	$PanelContainer/PanelText.bbcode_text = data;
	$PanelContainer/PanelText.visible = true


func _on_Quit_button_up():
	# TODO: stop natives
	get_tree().quit()
