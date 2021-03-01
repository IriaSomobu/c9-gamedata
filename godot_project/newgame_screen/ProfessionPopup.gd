extends Popup

signal on_profession_selected(id)

onready var core = get_node("/root/Root").core;

var selected_id = "";

func _ready():
	pass


func _on_Items_item_selected(index):
	pass # Replace with function body.


func _on_Items_item_activated(index):
	_on_Items_item_selected(index)
	_on_Accept_pressed();


func _on_Cancel_pressed():
	hide()


func _on_Accept_pressed():
	emit_signal("on_profession_selected", selected_id)
	hide()
