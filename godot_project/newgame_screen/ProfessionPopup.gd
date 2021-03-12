extends Popup

signal on_profession_selected(id)

onready var core = get_node("/root/Root").core;

var loaded_sex_male = true
var loaded_profs = []
var selected_id = "";

func _ready():
	$Panel/Cancel.text = core.tr("Cancel")
	$Panel/Accept.text = core.tr("Confirm")

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
	var cost_color = " [color=" + ("red" if prof["cost"] > 0 else "green") + "]"
	var cost = core.tr("Cost:") + cost_color + str(prof["cost"]) + "[/color]"
	
	var addicts = "\n\n" + core.tr("Addictions:")
	if prof["addictions"].size() > 0:
		for addct in prof["addictions"]:
			addicts += "\n[color=grey]  " + addct + "[/color]"
	else:
		addicts += "\n[color=grey]  " + core.tr("None") + "[/color]"
	
	var traits = "\n\n" + core.tr("Profession traits:")
	if prof["traits_mandatory"].size() > 0:
		for tr in prof["traits_mandatory"]:
			var trait = get_parent().get_trait_by_id(tr);
			var trait_name = core.tr("Unknown") if trait == null else core.tr(trait["name"]);
			traits += "\n[color=grey]  " + trait_name + "[/color]"
	else:
		traits += "\n[color=grey]  " + core.tr("None") + "[/color]"
	
	var skills = "\n\n" + core.tr("Profession skills:")
	if prof["skills"].size() > 0:
		for s in prof["skills"]:
			skills += "\n[color=grey]  " + s + "[/color]"
	else:
		skills += "\n[color=grey]  " + core.tr("None") + "[/color]"
	
	var bio = "\n\n" + core.tr("Profession bionics:")
	if prof["bionics"].size() > 0:
		for b in prof["bionics"]:
			bio += "\n[color=grey]  " + b + "[/color]"
	else:
		bio += "\n[color=grey]  " + core.tr("None") + "[/color]"
	
	var worn = core.tr("Worn:")
	if prof["worn_m" if loaded_sex_male else "worn_f"].size() > 0:
		for b in prof["worn_m" if loaded_sex_male else "worn_f"]:
			worn += "\n[color=grey]  " + b + "[/color]"
	else:
		worn += "\n[color=grey]  " + core.tr("None") + "[/color]"
	
	var inv = "\n\n" + core.tr("Inventory:")
	if prof["inv_m" if loaded_sex_male else "inv_f"].size() > 0:
		for b in prof["inv_m" if loaded_sex_male else "inv_f"]:
			inv += "\n[color=grey]  " + b + "[/color]"
	else:
		inv += "\n[color=grey]  " + core.tr("None") + "[/color]"
	
	var text = descr + "\n\n" + cost;
	text += addicts + traits + skills + bio;
	$Panel/InfoText.bbcode_text = text;
	$Panel/InfoText2.bbcode_text = worn + inv;


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
