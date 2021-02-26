extends Control


func loading_screen_show():
	visible = true
	print("Loading screen show");

func loading_screen_hide():
	visible = false
	print("Loading screen hide");

func loading_screen_stage(stagename):
	$Stage.text = stagename;

func loading_screen_entry(entryname):
	$Progress.text = entryname;
