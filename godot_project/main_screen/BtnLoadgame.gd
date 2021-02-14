tool extends Button

export var worldname = "Unknown World" setget s_world
export var charname = "Unknown Character" setget s_char
export var playtime = "Unknown Playtime" setget s_time

var id = -1;

signal savegame_pressed(id)

func s_world(name):
	worldname = name
	$Control/World.text = name

func s_char(name):
	charname = name
	$Control/Char.text = name

func s_time(name):
	playtime = name
	$Control/Date.text = name

func _on_BtnLoadgame_pressed():
	emit_signal("savegame_pressed", id)
