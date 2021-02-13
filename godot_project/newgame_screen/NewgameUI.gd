extends Control

func set_mode(mode):
	$Label.text += "\nIn mode \""+str(mode)+"\""

func fuck_go_back():
	get_node("/root/Root").goto_main();
