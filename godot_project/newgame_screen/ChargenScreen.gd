extends Control

onready var core = get_node("/root/Root").core;

const single_pool_limit = 8
const multi_pool_limit = [6, 0, 2]
const generic_prof_id = "unemployed"

var chargen_data;

var selected_gender_male = true
var selected_scenario_idx = 0;
var selected_profession_id = generic_prof_id;


func _ready():
	$BtnBack.text      = core.tr("Back")
	$BtnConfirm.text   = core.tr("Confirm")
	
	$Basic/SexLabel.text     = core.tr("Sex")
	$Basic/NameLabel.text    = core.tr("Name")
	$Basic/HeightLabel.text  = core.tr("Height")
	$Basic/AgeLabel.text     = core.tr("Age")
	
	$Basic/Sex.add_item(core.tr("male"))
	$Basic/Sex.add_item(core.tr("female"))
	
	$Appearance/SkinColorLabel.text      = core.tr("Skin color");
	$Appearance/HairLabel.text           = core.tr("Hair");
	$Appearance/FaceHairLabel.text       = core.tr("Facial hair")
	$Appearance/AdditFeaturesLabel.text  = core.tr("Additional features");
	
	$StartProps/ScenarioLabel.text   = core.tr("Scenario")
	$StartProps/ProfessionLabel.text = core.tr("Profession")
	$StartProps/LocationLabel.text   = core.tr("Location")
	$StartProps/VehicleLabel.text    = core.tr("Vehicle")


func char_data_ld(data):
	chargen_data = data;
	
	$ScenarioPopup.data(data["scenarios"])
	
	rand_name();
	
	for scenario in data["scenarios"]:
		if scenario["is_default"]:
			select_scenario(selected_scenario_idx)
			break;
		selected_scenario_idx += 1
	
	update_points_label();


func rand_name():
	$Basic/Name.text = core.get_random_name(selected_gender_male);


func select_scenario(idx):
	selected_scenario_idx = idx;
	var name_field = "name_m" if selected_gender_male else "name_f"
	$StartProps/Scenario.text = chargen_data["scenarios"][idx][name_field];
	set_default_prof_for_scenario(chargen_data["scenarios"][idx]["id"])


func get_points_left():
	var result = single_pool_limit + 0;
	
	result -= chargen_data["scenarios"][selected_scenario_idx]["cost"];
	
	return result;


func get_prof_by_id(prof_id):
	for prof in chargen_data["profs"]:
		if prof["id"] == prof_id:
			return prof;
	
	return null;


func get_default_prof_for_scenario(scenatio_id):
	
	var prof_id = null
	
	for scenario in chargen_data["scenarios"]:
		if scenario["id"] == scenatio_id:
			if scenario["permitted_profs"].has(generic_prof_id):
				prof_id = generic_prof_id;
			else:
				prof_id = scenario["permitted_profs"][0];
			break;
	
	return get_prof_by_id(prof_id)


func set_default_prof_for_scenario(scenario_id):	
	var prof = get_default_prof_for_scenario(scenario_id);
	selected_profession_id = prof["id"]
	
	var name_field = "name_m" if selected_gender_male else "name_f"
	$StartProps/Profession.text = prof[name_field]


func update_points_label():
	$Points.text = core.tr("Points left:") + " " + str(get_points_left());


func _on_NameRandom_pressed():
	rand_name();


func _on_Sex_item_selected(id):
	selected_gender_male = (id == 0);
	rand_name();
	select_scenario(selected_scenario_idx) # Reload scenario selection to update gender text


func _on_Scenario_pressed():
	$ScenarioPopup.show_panel(selected_scenario_idx);

func _on_Profession_pressed():
#	$ScenarioPopup.show_panel(selected_scenario_idx);
	$ProfessionPopup.popup();

func _on_ScenarioPopup_scenario_selected(idx):
	select_scenario(idx)
	update_points_label()


func _on_BtnBack_pressed():
	get_parent().show_world_panel();


func _on_BtnConfirm_pressed():
	get_parent().confirm();

