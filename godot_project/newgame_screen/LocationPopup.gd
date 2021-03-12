extends Popup

signal on_location_selected(id)

onready var core = get_node("/root/Root").core;

var loaded_locs = []
var selected_id = "";

func _ready():
	$Panel/Cancel.text = core.tr("Cancel")
	$Panel/Accept.text = core.tr("Confirm")

func show_panel(loclist, permitted_ids, _selected_id):
	
	var selected_idx = 0
	selected_id = _selected_id;
	
	loaded_locs = [ { "id":"random", "name":core.tr("Random location")} ]
	var idx = 0
	for id in permitted_ids:
		for loc in loclist:
			if loc["id"] == id:
				loaded_locs.append(loc)
		
		if id == _selected_id:
			selected_idx = idx
		
		idx += 1
	
	$Panel/Items.clear();
	for loc in loaded_locs:
		$Panel/Items.add_item(loc["name"])
	
	$Panel/Items.select(selected_idx)
	select(selected_idx)
	popup();


func select(idx):
	selected_id = loaded_locs[idx]["id"]


func _on_Items_item_selected(index):
	select(index)


func _on_Items_item_activated(index):
	_on_Items_item_selected(index)
	_on_Accept_pressed();


func _on_Cancel_pressed():
	hide()


func _on_Accept_pressed():
	emit_signal("on_location_selected", selected_id)
	hide()
