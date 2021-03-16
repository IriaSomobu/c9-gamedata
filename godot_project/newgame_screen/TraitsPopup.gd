extends Popup

signal on_location_selected(id)

onready var core = get_node("/root/Root").core;

var trait_item = load("res://newgame_screen/TraitItem.tscn");

var all_traits = []
var all_forced = []
var all_blocked = []


func _ready():
	$Panel/Tabs.add_item(core.tr("Positive trairs"))
	$Panel/Tabs.add_item(core.tr("Negative trairs"))
	$Panel/Tabs.add_item(core.tr("Neutral trairs"))
	$Panel/Accept.text = core.tr("Confirm")


func show_panel(_all_traits, blocked, forced):
	all_traits = _all_traits;
	all_blocked = blocked;
	all_forced = forced;
	
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
		
		instance.connect("state_changed", self, "on_item_state")


func on_item_state(id, state):
	print("item state ", id, " ", state)


func on_tab_selected(idx):
	reload_by_group(idx)


func _on_Accept_pressed():
	hide()

