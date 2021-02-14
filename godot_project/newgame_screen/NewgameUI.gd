extends Control

onready var core = get_node("/root/Root").core;

func set_mode(mode):
	$Worldgen.visible = true
	$Chargen.visible = false

func back_to_main():
	get_node("/root/Root").goto_main()

func to_chargen():
	$Worldgen.visible = false
	$Chargen.visible = true

func back_to_mapgen():
	$Worldgen.visible = true
	$Chargen.visible = false

func confirm():
	pass
