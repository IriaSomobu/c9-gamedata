extends Control

signal state_changed(id, enabled)

var id = "";
var description = "";
var enabled = false
var active = true


func _ready():
	set_state(enabled)


func set_data(_id, name, descr, cost):
	id = _id;
	if descr.length() > 96: descr = descr.substr(0, 96) + "..."
	description = descr  + "\nCost: "+str(cost);
	
	$Label.text = name;
	$".".hint_tooltip = description


func set_state(enabled):
	self.enabled = enabled
	$CheckBox.pressed = enabled


func set_active(active):
	self.active = active
	$".".disabled = not active


func _on_TraitItem_pressed():
	set_state(not enabled)
	emit_signal("state_changed", id, enabled)
