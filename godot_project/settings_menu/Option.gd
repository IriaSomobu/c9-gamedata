tool extends Button

signal option_changed(codename, value)

onready var core = get_node("/root/Root").core;

export var title = "" setget s_title;
export var descr = "";
export var code = "";

var values = { "na":"N/A" };
var current_value = "" setget s_value;

func _ready():
	pass 

func s_title(val):
	title = val;
	upd_vis();

func s_value(val):
	current_value = val;
	upd_vis();

func upd_vis():
	$Name.text = title;
	
	if values.has(current_value): 
		$Value.text = values[current_value]
	else: 
		$Value.text = current_value;
	

func be_empty():
	for child in get_children():
		child.visible = false;

func be_boolean(vals):
	values = vals;

func be_number(min_val, max_val, step):
	values.clear();
	
	for i in range(min_val, max_val, step):
		values[str(i)] = str(i);

func be_string():
	$BtnLeft.visible = false
	$BtnRight.visible = false
	$Value.text = "Disabled"

func get_val_offsetted(var by):
	var keys = values.keys()
	var idx = keys.find(current_value)
	
	return keys[ (idx+by) % keys.size() ]

func _on_btn_prev_pressed():
	var value =get_val_offsetted(-1)
	s_value(value)
	emit_signal("option_changed", code, value)

func _on_btn_next_pressed():
	var value =get_val_offsetted(+1)
	s_value(value)
	emit_signal("option_changed", code, value)

func rangef(start: float, end: float, step: float):
	var res = Array()
	var i = start
	while i < end:
		res.push_back(i)
		i += step
	return res
