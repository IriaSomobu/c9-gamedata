extends Control


func _ready():
	pass # Replace with function body.


func set_error(title, message):
	$Panel/Title.text = title;
	$Panel/Message.text = message;


func _on_CloseBtn_button_up():
	get_tree().quit()
