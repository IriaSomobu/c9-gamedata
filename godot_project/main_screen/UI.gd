extends Control

func core_data(data):
	$AppLogo.text = data["logo"]["name"]
	$MOTD.text = data["motd"]["name"]
	$NewGame.text = data["ng"]["name"]
	$Load.text = data["lg"]["name"]
	$World.text = data["world"]["name"]
	$Settings.text = data["sets"]["name"]
	$Help.text = data["help"]["name"]
	$Credits.text = data["titles"]["name"]
	$Quit.text = data["exit"]["name"]
	$Tips.bbcode_text = data["tips"]["tip"]

func _ready():
	$MOTD.grab_focus()
