tool extends Button

export var title = "" setget t_set
export var subtitle = "" setget s_set

var has_focus = false;
var has_mouse = false;

func t_set(newval):
	title = newval
	$DefaultLabel.text = title
	$HoveredLabel.text = title

func s_set(newval):
	subtitle = newval
	$RichTextLabel.bbcode_text = subtitle



func _on_BtnNewgame_focus_entered():
	has_focus = true
	upd_vis();

func _on_BtnNewgame_focus_exited():
	has_focus = false
	upd_vis();

func _on_BtnNewgame_mouse_entered():
	has_mouse = true
	upd_vis();

func _on_BtnNewgame_mouse_exited():
	has_mouse = false
	upd_vis();

func upd_vis():
	var active = has_focus or has_mouse;
	$DefaultLabel.visible = not active
	$HoveredLabel.visible = active
	$RichTextLabel.visible = active

