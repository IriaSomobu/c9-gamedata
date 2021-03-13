extends Popup

signal skill_updated(idx, new_val)

onready var core = get_node("/root/Root").core;

var skills = []
var points = []
var selected_idx = 0

func _ready():
	$Panel/Accept.text = core.tr("Confirm")


func show_panel(_skills, _points):
	skills = _skills
	points = _points
	
	$Panel/Items.clear();
	for i in range(skills.size()):
		$Panel/Items.add_item(skills[i]["name"] + " [" + str(points[i]) + "]")
	
	$Panel/Items.select(0)
	select_item(0)
	popup();
	$Panel/Items.grab_focus()


func select_item(index):
	selected_idx = index
	var name = skills[selected_idx]["name"];
	var descr = "[color=grey]" + skills[selected_idx]["descr"] + "[/color]";
	$Panel/InfoText.bbcode_text = name + "\n\n" + descr
	$Panel/Value.text = str(points[selected_idx])


func _on_Cancel_pressed():
	hide()


func _on_Accept_pressed():
	hide()


func alter_skill(dir):
	points[selected_idx] += dir
	if points[selected_idx] < 1: points[selected_idx] = 1
	if points[selected_idx] > 10: points[selected_idx] = 10
	
	$Panel/Items.add_item(skills[selected_idx]["name"] + " [" + str(points[selected_idx]) + "]")
	$Panel/Items.remove_item(selected_idx)
	$Panel/Items.move_item(skills.size() - 1, selected_idx)
	$Panel/Items.select(selected_idx)
	select_item(selected_idx)
	
	emit_signal("skill_updated", selected_idx, points[selected_idx])


func _on_Minus_pressed():
	alter_skill(-1)


func _on_Plus_pressed():
	alter_skill(+1)
