extends Control

onready var core = get_node("/root/Root").core;


func set_mode(mode):
	$Worldgen.setup();
	show_world_panel();


# World panel
func show_world_panel():
	$Worldgen.visible = true
	$Chargen.visible = false
	$Worldgen/Modlist/ScrollContainer/GridContainer.get_child(0).grab_focus()


func back_to_main():
	get_node("/root/Root").goto_main()


func to_chargen(mods, options):
	core.create_tmp_world(options, mods);
	core.load_chargen(get_node("Chargen"));
	$Worldgen.visible = false
	$Chargen.visible = true


func confirm():
	back_to_main();
