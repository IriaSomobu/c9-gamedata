extends Popup

signal on_location_selected(id)

onready var core = get_node("/root/Root").core;

var trait_item = load("res://newgame_screen/TraitItem.tscn");

func _ready():
	$Panel/Tabs.add_item(core.tr("Positive trairs"))
	$Panel/Tabs.add_item(core.tr("Negative trairs"))
	$Panel/Tabs.add_item(core.tr("Neutral trairs"))
	$Panel/Accept.text = core.tr("Confirm")
	
	var descr = "You have a unique history with stimulants (like coffee or amphetamines). You can tolerate a lot more of them without overdosing, but if you indulge too mush, you start seeing things..."
	
	item(core.tr("Stimulant Psychosis"),  "descr", 0)
	item(core.tr("Accomplished Sleeper"), "descr", 0)
	item(core.tr("Addiction Resistant"),  "descr", 0)


func item(name, descr, cost):
	var instance = trait_item.instance();
	$Panel/Items.make_scrollable(instance)
	$Panel/Items/GridContainer.add_child(instance)
	instance.set_data(name, descr, cost)


func show_panel():
	popup();


func select(idx):
	pass


func _on_Items_item_selected(index):
	select(index)


func _on_Items_item_activated(index):
	_on_Items_item_selected(index)
	_on_Accept_pressed();


func _on_Accept_pressed():
	hide()
