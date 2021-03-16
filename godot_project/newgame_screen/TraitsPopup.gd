extends Popup

signal on_traitslist_changed(list)

onready var core = get_node("/root/Root").core;

var trait_item = load("res://newgame_screen/TraitItem.tscn");

var all_traits = []
var all_forced = []
var all_blocked = []

var selected_traits = []

func _ready():
	$Panel/Tabs.add_item(core.tr("Positive trairs"))
	$Panel/Tabs.add_item(core.tr("Negative trairs"))
	$Panel/Tabs.add_item(core.tr("Neutral trairs"))
	$Panel/Accept.text = core.tr("Confirm")


func show_panel(_all_traits, blocked, forced):
	all_traits = _all_traits;
	all_blocked = blocked;
	all_forced = forced;
	
	selected_traits = []
	for trait in all_forced: selected_traits.append(trait)
	
	$Panel/Tabs.select(0)
	reload_by_group(0)
	
	popup();


func reload_by_group(idx):
	
	for child in $Panel/Items/GridContainer.get_children(): child.queue_free()
	
	for trait in all_traits:
		if idx == 0 and trait["cost"] <= 0: continue
		if idx == 1 and trait["cost"] >= 0: continue
		if idx == 2 and trait["cost"] != 0: continue
		
		var instance = trait_item.instance();
		$Panel/Items.make_scrollable(instance)
		$Panel/Items/GridContainer.add_child(instance)
		instance.set_data(trait["id"], trait["name"], trait["descr"], trait["cost"])
		
		if trait["id"] in all_forced:
			instance.set_active(false)
			instance.set_state(true)
		
		if trait["id"] in all_blocked:
			instance.set_active(false)
			instance.set_state(false)
		
		if trait["id"] in selected_traits:
			instance.set_state(true)
		
		instance.connect("state_changed", self, "on_item_state")
	
	upd_point_counter(idx)


func get_trait(id):
	for trait in all_traits:
		if trait["id"] == id:
			return trait
	return null


func get_point_count(idx):
	var cnt = 0
	
	for trait in all_traits:
		if trait["id"] in selected_traits:
			if idx == 0 and trait["cost"] > 0: cnt += trait["cost"]
			if idx == 1 and trait["cost"] < 0: cnt -= trait["cost"]
	
	return cnt


func upd_point_counter(idx):
	if idx == 0 or idx == 1:
		var text = core.tr("Points left:");
		$Panel/Label.text = text + " " + str(get_point_count(idx)) + "/12"
	else:
		$Panel/Label.text = "TODO: properly implement traits blocking here"


func on_item_state(ref, id, state):
	
	if state:
		var trait = get_trait(id);
		var cost = trait["cost"] if $Panel/Tabs.selected == 0 else -trait["cost"]
		
		if get_point_count($Panel/Tabs.selected) + cost > 12:
			ref.set_state(false)
			$AcceptDialog.popup()
			return
		
		var idx = selected_traits.find(id)
		if(idx < 0): selected_traits.append(id)
	else:
		var idx = selected_traits.find(id)
		if(idx >= 0): selected_traits.remove(idx)
	
	upd_point_counter($Panel/Tabs.selected)
	emit_signal("on_traitslist_changed", selected_traits)


func on_tab_selected(idx):
	reload_by_group(idx)


func _on_Accept_pressed():
	hide()
