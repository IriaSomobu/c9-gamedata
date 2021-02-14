extends Control

onready var core = get_node("/root/Root").core;
var save_button = load("res://main_screen/BtnLoadgame.tscn");

var saves = [];
var popup_idx = -1;

func _ready():
	reload_saves();

func reload_saves():
	for child in $ScrollContainer/GridContainer.get_children():
		$ScrollContainer/GridContainer.remove_child(child)
	
	saves = core.list_saves();
	
	$NosavesPanel.visible = saves.size() == 0
	
	var idx = 0;
	for save in saves:
		var btn = save_button.instance();
		btn.worldname = save["world"];
		btn.charname = save["char"];
		btn.playtime = save["time"];
		btn.id = idx;
		
		$ScrollContainer/GridContainer.add_child(btn);
		
		btn.connect("savegame_pressed", self, "on_save_pressed")
		
		idx += 1

func on_save_pressed(id):
	var text = saves[id]["world"] + "\n" + saves[id]["char"];
	$PopupPanel/Content/Container/Label.text = text;
	$PopupPanel.popup();
	popup_idx = id;


func popup_load():
	get_node("/root/Root").goto_loading();


func popup_delete():
	$ConfirmationDialog.popup();


func popup_cancel():
	$PopupPanel.hide();


func on_delete_confirmed():
	core.delete_save(saves[popup_idx]["world"]);
	$PopupPanel.hide();
	reload_saves();
