extends Control

var character_data;
func char_data_ld(data):
	character_data = data;
	
	for scenario in data["scenarios"]:
		if scenario["is_default"]:
			select_scenario(scenario)
			break;
	
	


func _on_Scenario_pressed():
	$ScenarioPopup.popup();


func select_scenario(data):
	$StartProps/Scenario.text = data["name_m"]


func _on_BtnBack_pressed():
	get_parent().show_world_panel();


func _on_BtnConfirm_pressed():
	get_parent().confirm();
