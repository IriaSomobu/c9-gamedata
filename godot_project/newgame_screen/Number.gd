tool extends Control

signal value_changed(current_value)

export var min_max = Vector2(4, 20)
export var value = 0 setget set_value, get_value


func _ready():
	set_value(value)


func set_value(val):
	value = val
	
	if value <= min_max.x: value = min_max.x
	if value >= min_max.y: value = min_max.y
	
	if $Number != null:
		$Number.text = str(value as int)

func get_value():
	return value


func _on_Left_pressed():
	set_value(value - 1)
	emit_signal("value_changed", value)


func _on_Right_pressed():
	set_value(value + 1)
	emit_signal("value_changed", value)
