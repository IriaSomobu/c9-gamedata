extends Control

func loading_screen_show():
	visible = true

func loading_screen_hide():
	visible = false

func loading_screen_stage(stagename):
	$Stage.text = stagename;
	$Progress.text = "";

func loading_screen_entry(entryname):
	$Progress.text = entryname;
