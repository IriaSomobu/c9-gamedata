extends Popup

signal on_profession_selected(id)

onready var core = get_node("/root/Root").core;

var loaded_sex_male = true
var loaded_profs = []
var selected_id = "";

func _ready():
	pass

func show_panel(profs, permitted_ids, _selected_id):
	
	var selected_idx = 0
	selected_id = _selected_id;
	
	loaded_profs = []
	var idx = 0
	for id in permitted_ids:
		for prof in profs:
			if prof["id"] == id:
				loaded_profs.append(prof)
		
		if id == _selected_id:
			selected_idx = idx
		
		idx += 1
	
	
	var is_male = get_parent().selected_gender_male
	loaded_sex_male = is_male
	var name_field = "name_m" if is_male else "name_f"
	
	$Panel/Items.clear();
	for prof in loaded_profs:
		$Panel/Items.add_item(prof[name_field])
	
	$Panel/Items.select(selected_idx)
	select(selected_idx)
	popup();


func select(idx):
	var prof = loaded_profs[idx]
	selected_id = prof["id"]
	
	var desc_field = "desc_m" if loaded_sex_male else "desc_f"
	var descr = "[color=#5C5]" + prof[desc_field] + "[/color]"
	var cost = core.tr("Cost:") + " [color=grey]" + str(prof["cost"]) + "[/color]"
	
	var text = descr + "\n\n" + cost
	$Panel/InfoText.bbcode_text = text;


func _on_Items_item_selected(index):
	select(index)


func _on_Items_item_activated(index):
	_on_Items_item_selected(index)
	_on_Accept_pressed();


func _on_Cancel_pressed():
	hide()


func _on_Accept_pressed():
	emit_signal("on_profession_selected", selected_id)
	hide()
