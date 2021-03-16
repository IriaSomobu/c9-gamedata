extends Control

onready var core = get_node("/root/Root").core;

const single_pool_limit = 24
const multi_pool_limit = [6, 0, 2]
const generic_prof_id = "unemployed"

var chargen_data;

var selected_gender_male = true
var selected_scenario_idx = 0;
var selected_profession_id = generic_prof_id;
var selected_location_id = "random";
var skill_points = []
var selected_traits_ids = []

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
	
	
	$Stats/StrLabel.text     = core.tr("Strength")
	$Stats/DexLabel.text     = core.tr("Dexterity")
	$Stats/IntelLabel.text   = core.tr("Intelligence")
	$Stats/PerceptLabel.text = core.tr("Perception")
	
	$Stats/StrLabel.hint_tooltip      = core.tr("Defines base HP, carry weight and melee damage bonus")
	$Stats/StrLabel.hint_tooltip             += "\n\n" + core.tr("Strength also makes you more resistant to many diseases and poisons, and makes actions which require brute force more effective.")
	$Stats/DexLabel.hint_tooltip      = core.tr("Defines to-hit bonus, throwing and ranged penalies")
	$Stats/DexLabel.hint_tooltip             += "\n\n" + core.tr("Dexterity also enhances many actions which require finesse.")
	$Stats/IntelLabel.hint_tooltip    = core.tr("Defines crafring bouns and skill rust")
	$Stats/IntelLabel.hint_tooltip           += "\n\n" + core.tr("Intelligence is also used when crafting, installing bionics, and interacting with NPCs.")
	$Stats/PerceptLabel.hint_tooltip  = core.tr("Defines aiming penalty")
	$Stats/PerceptLabel.hint_tooltip         += "\n\n" + core.tr("Perception is also used for detecting traps and other things of interest.")
	
	$Traits/Edit.text = core.tr("Edit")
	$Skills/Edit.text = core.tr("Edit")
	
	$NegativePointsPopup.dialog_text = core.tr("Too many points allocated, change some features and try again.")


func char_data_ld(data):
	chargen_data = data;
	
	$ScenarioPopup.data(data["scenarios"])
	
	rand_name();
	
	for scenario in data["scenarios"]:
		if scenario["is_default"]:
			select_scenario(selected_scenario_idx)
			set_default_prof_for_scenario(chargen_data["scenarios"][selected_scenario_idx]["id"])
			set_default_loc_for_scenario(selected_scenario_idx)
			break;
		selected_scenario_idx += 1
	
	for i in range(data["skills"].size()):
		skill_points.append(1)
	
	update_points_label();
	update_traits_label();
	update_skills_label();


func rand_name():
	$Basic/Name.text = core.get_random_name(selected_gender_male);


func select_scenario(idx):
	selected_scenario_idx = idx;
	var name_field = "name_m" if selected_gender_male else "name_f"
	$StartProps/Scenario.text = chargen_data["scenarios"][idx][name_field];


func select_prof(id):
	var prof = get_prof_by_id(id)
	selected_profession_id = id
	
	var name_field = "name_m" if selected_gender_male else "name_f"
	$StartProps/Profession.text = prof[name_field]


func select_location(id):
	selected_location_id = id;
	
	var locname = "";
	if id == "random":
		locname = core.tr("Random location");
	else:
		var loc = get_loc_by_id(id)
		locname = loc["name"]
	$StartProps/Location.text = locname


func get_points_left():
	var result = single_pool_limit + 0;
	
	result -= chargen_data["scenarios"][selected_scenario_idx]["cost"];
	result -= get_prof_by_id(selected_profession_id)["cost"];
	
	result -= calc_stat_point($Stats/Str.value)
	result -= calc_stat_point($Stats/Dex.value)
	result -= calc_stat_point($Stats/Intel.value)
	result -= calc_stat_point($Stats/Percept.value)
	
	for trait in chargen_data["traits"]:
		if trait["id"] in selected_traits_ids:
			result -= trait["cost"]
	
	for i in range(skill_points.size()):
		var x = skill_points[i]
		result -= floor(0.25 * x * x)
	
	return result;


func calc_stat_point(value):
	var rz = value - 4
	
	if value >= 14:
		rz += value - 14
	
	return rz


func rebuild_selected_traits():
	selected_traits_ids = []
	
	var by_prof = get_prof_by_id(selected_profession_id)["trait_ids_mandatory"]
	for id in by_prof: selected_traits_ids.append(id)


func get_prof_by_id(prof_id):
	for prof in chargen_data["profs"]:
		if prof["id"] == prof_id:
			return prof;
	
	return null;


func get_trait_by_id(trait_id):
	for trait in chargen_data["traits"]:
		if trait["id"] == trait_id:
			return trait;
	
	return null;


func get_loc_by_id(loc_id):
	for loc in chargen_data["locs"]:
		if loc["id"] == loc_id:
			return loc;
	
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
	select_prof(prof["id"])


func set_default_loc_for_scenario(scenario_idx):
	var permitted = chargen_data["scenarios"][scenario_idx]["loclist"]
	
	if permitted.size() == 1:
		select_location(permitted[0])
	else:
		select_location("random")


func update_points_label():
	var left = get_points_left() as int
	$Points.text = core.tr("Points left:") + " " + str(left);
	$Points.set("custom_colors/font_color", Color.red if left < 0 else Color.white);


func update_traits_label():
	var text = core.tr("Traits:")
	var appended = false
	
	for trait in chargen_data["traits"]:
		if trait["id"] in selected_traits_ids:
			text += "\n  " + trait["name"]
			appended = true
			
	if not appended:
		text += "\n  "+core.tr("None")
	
	$Traits/Label.bbcode_text = text;


func update_skills_label():
	var text = core.tr("Skills:")
	var appended = false
	
	for i in range(skill_points.size()):
		var points = skill_points[i]
		if points > 1:
			text += "\n  "+chargen_data["skills"][i]["name"] + " ["+str(points)+"]"
			appended = true
	
	if not appended:
		text += "\n  "+core.tr("Default")
	
	$Skills/Label.bbcode_text = text;


func _on_NameRandom_pressed():
	rand_name();


func _on_Sex_item_selected(id):
	selected_gender_male = (id == 0);
	rand_name();
	select_scenario(selected_scenario_idx) # Reload scenario selection to update gender text
	select_prof(selected_profession_id)


func _on_Scenario_pressed():
	$ScenarioPopup.show_panel(selected_scenario_idx);


func _on_Profession_pressed():
	var profs = chargen_data["profs"];
	var ids = chargen_data["scenarios"][selected_scenario_idx]["permitted_profs"];
	$ProfessionPopup.show_panel(profs, ids, selected_profession_id);


func _on_Location_pressed():
	var locs = chargen_data["locs"];
	var ids = chargen_data["scenarios"][selected_scenario_idx]["loclist"]
	$LocationPopup.show_panel(locs, ids, selected_location_id);


func _on_TraitsEdit_pressed():
	var blocked = []
	var forced = []
	
	var prof = get_prof_by_id(selected_profession_id);
	for trait in prof["trait_ids_mandatory"]: forced.append(trait)
	for trait in prof["trait_ids_forbidden"]: blocked.append(trait)
	
	$TraitsPopup.show_panel(chargen_data["traits"], blocked, forced)


func _on_SkillsEdit_pressed():
	$SkillsPopup.show_panel(chargen_data["skills"], skill_points)


func _on_ScenarioPopup_scenario_selected(idx):
	select_scenario(idx)
	set_default_prof_for_scenario(chargen_data["scenarios"][idx]["id"])
	set_default_loc_for_scenario(selected_scenario_idx)
	update_points_label()


func _on_ProfessionPopup_on_profession_selected(id):
	select_prof(id)
	rebuild_selected_traits()
	update_points_label()
	update_traits_label()


func _on_LocationPopup_on_location_selected(id):
	select_location(id)


func _on_Stat_changed(current_value):
	update_points_label()


func _on_TraitsPopup_on_traitslist_changed(list):
	selected_traits_ids = list
	update_points_label()
	update_traits_label()


func _on_SkillsPopup_skill_updated(idx, new_val):
	skill_points[idx] = new_val
	update_points_label();
	update_skills_label();


func _on_BtnBack_pressed():
	get_parent().show_world_panel();


func _on_BtnConfirm_pressed():
	if get_points_left() < 0:
		$NegativePointsPopup.popup();
	else:
		get_parent().confirm();

