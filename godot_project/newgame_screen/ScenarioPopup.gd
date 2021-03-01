extends Popup

signal scenario_selected(idx)

onready var core = get_node("/root/Root").core;

var scenarios = [];
var loaded_sex_male = true
var selected_idx = 0;

func _ready():
	$Panel/Cancel.text = core.tr("Cancel")
	$Panel/Accept.text = core.tr("Confirm")


func data(_scenarios):
	scenarios = _scenarios;
	
	var is_male = get_parent().selected_gender_male
	loaded_sex_male = is_male
	var name_field = "name_m" if is_male else "name_f"
	
	$Panel/Items.clear();
	for scenario in scenarios:
		$Panel/Items.add_item(scenario[name_field])
	
	$Panel/Items.select(0)
	select_item(0)


func show_panel(selected):
	
	if get_parent().selected_gender_male != loaded_sex_male:
		data(scenarios)
	
	$Panel/Items.select(selected)
	select_item(selected)
	popup();


func select_item(index):
	selected_idx = index
	
	var is_male = get_parent().selected_gender_male
	var desc_field = "desc_m" if is_male else "desc_f"
	
	var s = scenarios[index]
	
	var default_prof = get_parent().get_default_prof_for_scenario(s["id"])
	var profname = default_prof["name_m"] if is_male else default_prof["name_f"]
	
	var descr = "[color=#5C5]" + s[desc_field] + "[/color]"
	var cost =      core.tr("Cost:")              + " [color=grey]" + str(s["cost"])     + "[/color]"
	var proflim =   core.tr("Professions:")       + " [color=grey]" + s["prof_limit"]    + "[/color]"
	var profdef =   core.tr("Default:")           + " [color=grey]" + profname           + "[/color]"
	var startloc =  core.tr("Scenario Location:") + " [color=grey]" + s["loc"]           + "[/color]"
	var startcnt =  core.tr("Total:")             + " [color=grey]" + str(s["loc_cnt"])  + "[/color]"
	var transport = core.tr("Scenario Vehicle:")  + " [color=grey]нет[/color]"
	var flags =     core.tr("Scenario Flags:")    + "\n[color=grey]нет[/color]"
	
	var text = descr + "\n\n" + cost  + "\n\n" +  proflim  + "\n" + profdef
	text += "\n\n" + startloc + "\n" + startcnt + "\n\n" + transport
	text += "\n\n" + flags
	
	$Panel/InfoText.bbcode_text = text;


func _on_Items_item_activated(index):
	select_item(index)
	_on_Accept_pressed();


func _on_Cancel_pressed():
	hide()


func _on_Accept_pressed():
	emit_signal("scenario_selected", selected_idx)
	hide()

